close all
clear
rgbImage = imread('retina1.jpg');
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows, columns, numberOfColorBands] = size(rgbImage);
% Display the original color image.
figure;
imshow(rgbImage);
title('Original Color Image');
% Enlarge figure to full screen.

% Extract the individual red, green, and blue color channels.
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

small_kernel = [0,1,0;1,-4,1;0,1,0];
LoG = [0,0,1,0,0;0,1,2,1,0;1,2,-16,2,1;0,1,2,1,0;0,0,1,0,0];
kernel1 = [0,0,3,2,2,2,3,0,0;0,2,3,5,5,5,3,2,0;3,3,5,3,0,3,5,3,3;2,5,3,-12,-23,-12,3,5,2;2,5,0,-23,-40,-23,0,5,2;2,5,3,-12,-23,-12,3,5,2;3,3,5,3,0,3,5,3,3;0,2,3,5,5,5,3,2,0;0,0,3,2,2,2,3,0,0];
% Construct Gaussian Kernel
sig=1;
m= ceil(7*sig); 
n=ceil(7*sig);

[h1, h2]=meshgrid(-(m-1)/2:(m-1)/2, -(n-1)/2:(n-1)/2);
hg= exp(-(h1.^2+h2.^2)/(2*sig^2));            %Gaussian function
h=hg ./sum(hg(:));


% Could be done easier with fspecial though!
% Convolve the three separate color channels.
% redBlurred = conv2(redChannel, h);
 greenBlurred = conv2(greenChannel, h);
 
final = conv2(greenBlurred,LoG);
 
final1 = ceil(final);
% blueBlurred = conv2(blueChannel, h);
% Recombine separate color channels into a single, true color RGB image.
% rgbImage2 = cat(3, uint8(redBlurred), uint8(greenBlurred), uint8(blueBlurred));
% Display the blurred color image.
test_test = uint8(greenBlurred);
test_edge = uint8(final);
test_edge1 = uint8(final1);
bw_image = imbinarize(test_edge1,'adaptive','Sensitivity',0.4);
[index,count] = bwlabel(bw_image,8);
[index_copy,count_copy] = bwlabel(bw_image,8);
for i=1:count
objseparate(:,:,i) = index == i;
end

objarea2 = sum(sum(objseparate));
j = 1 ;
for i = 1:count
    if (objarea2(i)< 40)
        area_eliminate(j) = i;  %fill the object which has less than the specified area in an array
    else
        area_eliminate(j) = 0;
    end
    j = j+1;
end

for i = 1:count
    if area_eliminate(i) >0
        [r,c] = find(index == i);
        test_edge1(r,c) = 0;
    end
end

% figure;
% imshow(test_edge);
figure;

imshow(test_edge1);
title('Blurred Color Image');