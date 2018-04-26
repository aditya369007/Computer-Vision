tic
clear
clc
I=double(imread('discs12.bmp'))/255;     % read the test image
T=double(imread('target.bmp'))/255;     % read the target image
[X, Y]=size(I); Z=zeros(X,Y);

Kmax=12;                               % the number of random walks
k_num_obj = 5;

N = 1000; %number of random walks
obj_count =1;
Oxy=round(rand(1,2)*X)+1;               % an initial position
L1=likelihood(I,T,Oxy,1);               % the initial likelihood
Io=drawcircle(I,Oxy,1);                 % locate the object
figure(1),imshow(Io);

for i = 1 : Kmax
    
    for j = 1 : N
        dummy1=Oxy(end-1:end)+round(randn(1,2)*20);       % random walk
        if i == 1
            Dxy = dummy1;
        else
            Dxy = [Oxy(1:end-2),dummy1];
        end
        Dxy=clip(Dxy,1,X);                  % make sure the position in the image
        x=Dxy(end-1);
        y=Dxy(end);
        L2=likelihood(I,T,Dxy,i);           % evaluate the likelihood
        v=min(1,L2/L1);                     % compute the acceptance ratio
        u=rand;                             % draw a sample uniformly in [0 1]
        if v>u
            Oxy=Dxy;     L1=L2;             % accept the move
            Io=drawcircle(I,Oxy,i);         % draw the new position
            
        end
        figure(1),imshow(Io);
        loop_counter=[i,j]
    end
    
    %save the cuurent location of the found object
    Location_bank{i,1} = Oxy;
    %adding a random object for next loop
    
        dummy=round(rand(1,2)*X)+1;
        Oxy = [Oxy , dummy];
        
   
end
toc
