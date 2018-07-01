clear
tic
image = imread('mosaicA.bmp');
map_img = imread('mapA.bmp');

v = VideoWriter('Kmeans_animate_5_A.avi'); %output vid file name
v.FrameRate = 4; %setting fps
open(v); %opening to begin writing


Num_scale=5;
Num_orien=8;

%gabor on the mosaic
gabor_on_big = gaborconvolve(image,Num_scale,Num_orien,3,2,0.65,1.5);
%from 6*4 to make it 1*24
gob_op_big = gabor_on_big(:)';

% calculating the abs value of each element in the 1*24 cell array



for i = 1 : size(gob_op_big,1)
    for j = 1 : size(gob_op_big,2)
        
        gob_bigop_abs{i,j} = abs(gob_op_big{i,j});
    end
end

%main goal is to form the feature vector table of each pixel
% a table matching the dimesnsions of the image has to be created
% which consists of all the feature vectors of each pixel

%splitting all the pixels from each gabor op to be placed together


for i = 1 : size(image,1)
    for j = 1 : size(image,2)
        for k = 1 : size(gob_bigop_abs,1)
            for l = 1 : size(gob_bigop_abs,2)
                box_of_gabor{i,j}(k,l) = gob_bigop_abs{k,l}(i,j);
            end
        end
    end
end

%vefifed that the operation above is actually correct

%now to calculate all the feature vectors

%creating a cell array for with all the fvs



k = 1;
for i = 1 : length(box_of_gabor)
    for j = 1 :length(box_of_gabor)
        
        fv_pixel_master(k,:) = (box_of_gabor{i,j});
        k = k + 1;
    end
end


%normalizig the so obtained master feature table


for i = 1 : size(fv_pixel_master,2)
    
    max_value(i) = max(fv_pixel_master(:,i));
    min_value(i) = min(fv_pixel_master(:,i));
    norm_fv_master(:,i) = (fv_pixel_master(:,i) - min_value(i))/ (max_value(i) - min_value(i));

end


%selecting centroids for the required number of k means
%as we have a table of all the feature vectors, a random point can be
%chosen by randoming the row number.
K_cent = 4;






%mosaic a
centroid{1} = fv_pixel_master(11385,:);
centroid{2} = fv_pixel_master(17141,:);
centroid{3} = fv_pixel_master(34360,:);
centroid{4} = fv_pixel_master(62644,:);


% %mosaic b
% centroid{1} = fv_pixel_master(16123,:);
% centroid{2} = fv_pixel_master(18566,:);
% centroid{3} = fv_pixel_master(51993,:);


for i = 1 : length(centroid)
    cent_mat(i,:) = centroid{i};
end

% for i = 1 : K_cent
% % random_color(i) = randi(255);
% 
% end
random_color = [1,85,170,255];

k_file2;
close(v);
toc