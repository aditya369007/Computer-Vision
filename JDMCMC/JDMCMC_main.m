clc;
clear 

close all;
tic
rng('shuffle');
 
vid = VideoWriter('MCMCnew3.avi');
vid.FrameRate = 100;
open(vid);


lambda = 0.5;
num_rnad_walk = 30; %Number of random walks for each iteration 
K_max_objs = 30; %Max objects
init_k = 5;

m_burn = 3;
skip_steps_burn = 2;
 


I=double(imread('discs3.bmp'))/255;     % read the test image
T=double(imread('target.bmp'))/255;
[rows,cols] = size(I);




num_obj = zeros(num_rnad_walk, 1);
num_obj(1) = init_k;

Oxy = cell(num_rnad_walk, 1);
Oxy{1} = [randi(rows, num_obj(1) , 1) randi(cols, num_obj(1), 1)];
Io = drawcircle(I, (Oxy{1})', num_obj(1));
figure(1); imshow(Io);

writeVideo(vid,Io);


like_fn = zeros(num_rnad_walk, 1);
like_fn(1) = likelihood(I, T, Oxy{1}, num_obj(1)) * poisspdf(num_obj(1), lambda); %aposterior for evaluation

fprintf('iteration 1');


for i = 2:num_rnad_walk
    fprintf('\niteration %d',i);
 
    a = rand;

    if a < 0.33 && num_obj(i-1) > 1
        fprintf('\tjump back')
        num_obj(i) = num_obj(i-1) - 1;%              
        
    elseif a < 0.66 && num_obj(i-1) < K_max_objs
               fprintf('\tjump fwd')

        num_obj(i) = num_obj(i-1) + 1;        
       
    else
        fprintf('\tno jump')
        num_obj(i) = num_obj(i-1);
        
    end
    
    % MCMC Gibbs sampling
    Oxy{i} = gibbs_sampling(I, T, num_obj(i),vid);
    % Accept or reject
    like_fn(i) = likelihood(I, T, Oxy{i}, num_obj(i)) * poisspdf(num_obj(i), lambda);    
    v = min(like_fn(i)/like_fn(i-1), 1);
   
    u0 = rand(1);
    if v > u0 %Accept jump with prob. of p_jump
        %keep the jump
        fprintf('\tjump accepted');        
    else %Reject jump
        fprintf('\tjump rejected');
        
        num_obj(i) = num_obj(i-1);
        Oxy{i} = Oxy{i-1};
        like_fn(i) = like_fn(i-1);
    end
    fprintf('\nnumber of objects = %d',num_obj(i));
    
end




%burn in step

Burn_Oxy = Oxy(m_burn + 1:skip_steps_burn:num_rnad_walk);
burn_num_obj = num_obj(m_burn + 1:skip_steps_burn:num_rnad_walk);


final_objs = round(mean(burn_num_obj));

 
K_Burn = Burn_Oxy(burn_num_obj == final_objs);
dimensions_num = length(K_Burn);
S = zeros(final_objs, 2, dimensions_num); 
for i = 1:dimensions_num
    S(:,:,i) = K_Burn{i};
end
Output = organisepoints(S);
Oxy_end = round(mean(Output,3));


final_op = drawcircle(I, Oxy_end, final_objs);
figure(2);imshow(final_op);
writeVideo(vid,final_op);

 
close(vid);
toc


