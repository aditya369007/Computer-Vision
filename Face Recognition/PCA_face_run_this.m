tic
clear
close all
clc
%reading all 60 traning face data to form vectors
for i=1:12
    for j=0:4
        file=sprintf('%s',int2str(i),'/',int2str(i),'_',int2str(j),'.bmp');
        face=imread(file);
        for k=1:90
            x=(k-1)*60+1;
            y=k*60;
            A((i-1)*5+1+j,x:y)=double(face(k,:));	% reshape the image into a vector
        end
    end
end

%computing the average face

avg_face = sum(A) / 60;

for i = 1 : 60
    sub_mean_face_mat(i,:) = A(i,:) - avg_face;
end

% A_caps = reshape(sub_mean_face_mat.',1,[]);

A_caps = sub_mean_face_mat;

% covariance_mat = A_caps * A_caps';
%
% covar_new = A_caps' * A_caps;

cov_mat = cov(A_caps);

[V,D] = eig(cov_mat);

% new_eig_vec = A_caps * V;

test = V(:,end);
testshow = reshape(test,60,90);
imshow(testshow',[])

diag_eig = diag(D);

den_energy = sum(diag_eig);
sum_2 = 0;
j=1;
for i = 5400 :-1: (5400-30)
    
    num_energy = diag_eig(i);
    sum_2 = sum_2 + num_energy;
    num_energy_mat(j) = sum_2;
    j = j+1;
end

energy = num_energy_mat/den_energy;
figure(1);
plot(energy)



%n = 5
%j = 12
i = 0;
for k = 1:12
    
    person_train_cell{k,1} = sub_mean_face_mat((1+i):(5+i),:);
    i = i +5;
end
counter = 1;
num_selections = 19; % eigenvectors
for p = 5400: -1: 5400-num_selections
    for j = 1 : 12
        sum_3 = 0;
        for n = 1 : 5
            
            dummy1 = person_train_cell{j,1}(n,:) *  V(:,p);
            sum_3 = sum_3 + dummy1;
            
        end
       alpha(j,counter) = sum_3/5;
      
    end
      counter = counter + 1;
     
end

%reconstructng a random image
counter = 1;
sum_face = 0;
for p = 5400: -1: 5400-num_selections
reconstruct = alpha(6,counter) * V(:,p);
sum_face = sum_face + reconstruct;
flag(counter) = p;
counter = counter + 1;
end

rep_img = sum_face + avg_face';
figure(2)
imshow(reshape(rep_img,60,90)',[])

PCA_recon
PCA_detection
PCA_face_unknown
PCA_recgnition

toc