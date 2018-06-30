close all
clear
clc
rgbImage = imread('retina4.jpg');
% Get the dimensions of the image.
[rows, columns, numberOfColorBands] = size(rgbImage);
% Display the original color image.
figure;

imshow(rgbImage);
title('original image');
% Enlarge figure to full screen.

%Extract the individual green color channel.

greenChannel = rgbImage(:, :, 2);

%setting up the parameters for the LoG kernel

sigg = 0.5;   
dim =5;
k = (dim-1)/2;
P=  zeros(dim,dim);

% LoG kernel

for i= 1:dim
    for j= 1:dim
        pt1 = 1/(2*sigg^4);
        pt2 = (((i-k-1)^2 + (j-k-1)^2)/sigg^2) - 2;
        pt3 = exp(-(((i-k-1)^2 + (j-k-1)^2)/(2*sigg^2)));
        P(i,j) = pt1 * pt2 * pt3;
    end
end

for i= 1:dim
    for j= 1:dim
        if (mod((i+j),2)==0)
            P(i,j) = ceil(P(i,j));
        else
            P(i,j) = floor(P(i,j));
        end
    end
end

P(1,1) = 0;
P(1,dim) = 0;
P(dim,1) = 0;
P(dim,dim) = 0;

% Construct Gaussian Kernel
sig=1;
m= 2*sig; 

[h1, h2]=meshgrid(-(m-1):(m-1), -(m-1):(m-1));
hg= exp(-(h1.^2+h2.^2)/(2*sig^2))*(1/(2*pi*sig^2));            
h=hg ./sum(hg(:));

% Blurring the image by convolution with the gaussian
 greenBlurred = conv2(greenChannel, h,'same');
 % Convolution of the blurred image with the LoG kernel
final = conv2(greenBlurred,P,'same');
%converting it to unsigned integer8 so that we can display
test_test = uint8(greenBlurred);
test_ege = uint8(final);
test_edge_copy = uint8(final);
figure;

imshow(test_test)
title('blurred image')
figure;

imshow(test_ege)
title('LoG convoluted image')


[rows_x_black,col_y_black] = size(test_ege);

%creating a blank image for zero crossings
zcimg = zeros(rows_x_black,col_y_black);
%zero crossings
for i = 2:rows_x_black-1
    for j = 2:col_y_black-1
        neg_count = 0;
        pos_count = 0;
        for a = -1:1
            for b= -1:1
                if(a~=0 && b ~= 0)
                    if(final(i+a,j+b)< 10)
                        neg_count = neg_count+1;
                    end
                        
                    if (final(i+a,j+b) > 10)
                        pos_count = pos_count + 1;
                    end
                end
            end
        end
       
        
        zero_cross = ((neg_count > 0)&&(pos_count>0));
        if(zero_cross)
            zcimg(i,j) = 1;
        end
    end
end

edge_detect_kar_re_pls = uint8(zcimg);
figure;

imshow(zcimg)
title('zero cross result')

% this method works but its very slow as it calculates the area of each object detected by bwlabel
% for i=1:count
% objseparate(:,:,i) = index == i;
% end
% 
% objarea2 = sum(sum(objseparate));
% dummy = 1 ;
% for i = 1:count
%     if (objarea2(i)< 40)
%         area_eliminate(dummy) = i;  %fill the object which has less than the specified area in an array
%     else
%         area_eliminate(dummy) = 0;
%     end
%     dummy = dummy+1;
% end
% 
% for i = 1:count
%     if area_eliminate(i) >0
%         [r,c] = find(index == i);
%         test_edge_copy(r,c) = 0;
%     end
% end

%counting and filtering the small objects as instructed in the word
%document


[index,count] = bwlabel(zcimg);

[index_x,index_y] = size(index);

for i=1:count
    [r,c] = find(index == i);
    payload = size(r,1);
    if(payload < 35)           %deleting the objects less than 25 in size
        zcimg(r,c) = 0;
    end
end


 figure;

imshow(zcimg);       
 title('Zero Cross Filter Results');                   
 % post processing the edge detections
q = bwmorph(zcimg,'thin',Inf);
 w = bwmorph(q,'clean');

figure;

imshow((w))
title('Final Result')

asadf = imoverlay(rgbImage,w,'white');
  figure;

imshow(asadf);       
 title(' Color overlapped Image');  

