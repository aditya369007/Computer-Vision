close all
clear
clc
%reading the image
rgbImage = imread('retina4.jpg');
greenChannel = rgbImage(:, :, 2);
figure;
imshow(greenChannel);
title('Green channel')

%setting up the gaussian for the rotational filters
dim = 3;
sig = 1;

h2=meshgrid(-(dim):(dim));

g = (1/sqrt(2*pi*sig^2))*exp(-h2.^2/(2*sig^2));

g_scaled = 10* g;
mean = g_scaled./(2*dim*sig);
mean_scaled =  mean;
%Matched gaussian function in the form of G(x,y) = g - m_0
G_Xy = g_scaled - mean_scaled;

G_negate = 1 - G_Xy;
 
rounder = round(G_negate);

Green_blur = conv2(greenChannel,rounder);


rotate0 = zeros(15,15);
[sizex,sizey] = size(rounder);

for i = 1 : sizex
    for j = 1 : sizey
        
        rotate0(i+4,j+3) = rounder(i,j);
    end
end
%creating masks sfor the rotation
rotate15 = imrotate(rotate0,15,'bicubic','crop');
rotate30 = imrotate(rotate0,30,'bicubic','crop');
rotate45 = imrotate(rotate0,45,'bicubic','crop');
rotate60 = imrotate(rotate0,60,'bicubic','crop');
rotate75 = imrotate(rotate0,75,'bicubic','crop');
rotate90 = imrotate(rotate0,90,'bicubic','crop');
rotate105 = imrotate(rotate0,105,'bicubic','crop');
rotate120 = imrotate(rotate0,120,'bicubic','crop');
rotate135 = imrotate(rotate0,135,'bicubic','crop');
rotate150 = imrotate(rotate0,150,'bicubic','crop');
rotate165 = imrotate(rotate0,165,'bicubic','crop');
%creation of the images
mask_0_degg = conv2(greenChannel,rotate0,'same');
mask_15_degg = conv2(greenChannel,rotate15,'same');
mask_30_degg = conv2(greenChannel,rotate30,'same');
mask_45_degg = conv2(greenChannel,rotate45,'same');
mask_60_degg = conv2(greenChannel,rotate60,'same');
mask_75_degg = conv2(greenChannel,rotate75,'same');
mask_90_degg = conv2(greenChannel,rotate90,'same');
mask_105_degg = conv2(greenChannel,rotate105,'same');
mask_120_degg = conv2(greenChannel,rotate120,'same');
mask_135_degg = conv2(greenChannel,rotate135,'same');
mask_150_degg = conv2(greenChannel,rotate150,'same');
mask_165_degg = conv2(greenChannel,rotate165,'same');

max_img = zeros(size(mask_0_degg,1),size(mask_0_degg,2));

%finding the max value pixel among all the generated image pixel values
for i = 1 : size(mask_0_degg,1)
    for j =1 : size(mask_0_degg,2)
        
        max_img(i,j) = max(mask_0_degg(i,j) , mask_15_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_30_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_45_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_60_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_75_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_90_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_105_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_120_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_135_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_150_degg(i,j));
        max_img(i,j) = max(max_img(i,j) , mask_165_degg(i,j));
        
    end
end

figure;
imshow(uint8(max_img));

level = graythresh(uint8(max_img));

BW = imbinarize(uint8(max_img),level);
figure;

imshow((BW));
title('maximum value image')
[index,count] = bwlabel(BW);

[index_x,index_y] = size(index);

for i=1:count
    [r,c] = find(index == i);
    payload = size(r,1);
    if(payload < 20)
        BW(r,c) = 0;
    end
end

figure;

imshow(BW);       
 title('Post processing of the detection');  
 
 q = bwmorph(BW,'thin',Inf);
 q= bwmorph(q,'clean');
 figure;

imshow(q);       
 title('Thin Color Image');  

 asadf = imoverlay(rgbImage,q,'blue');
  figure;

imshow(asadf);       
 title('Overlapped Color Image');  
 
