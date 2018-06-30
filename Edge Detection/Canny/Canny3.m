close all
clear
%loading the image
rgbImage = imread('retina3.jpg');

greenChannel = rgbImage(:, :, 2);
figure;
imshow(greenChannel);
title('Original Image')

%setting parameters for the gaussian function
sig=1.5;
m= 3*sig; 

[h1, h2]=meshgrid(-(m-1):(m-1), -(m-1):(m-1));
hg= exp(-(h1.^2+h2.^2)/(2*sig^2))*(1/(2*pi*sig^2));            %Gaussian function
h=hg ./sum(hg(:));

%blurring the image
 greenBlurred = conv2(greenChannel, h);
figure;
imshow(uint8(greenBlurred));
title('green blurred');

%Estimates for gradient along x and y
G_x =  [-1,0,1;-2,0,2;-1,0,1;];
G_y =  [1,2,1;0,0,0;-1,-2,-1];

%convolving to find the x and y gradients
grad_X_convolve = conv2(greenBlurred,G_x);
grad_Y_convolve = conv2(greenBlurred,G_y);

%magnitue
grad_magnitude = sqrt(grad_X_convolve.^2+grad_Y_convolve.^2);
%angle
grad_angle =  atan2(grad_Y_convolve,grad_X_convolve)*180/pi;

figure;
imshow(uint8(grad_X_convolve));
title('x gradient');

figure;
imshow(uint8(grad_Y_convolve));
title('Y gradient');
figure;
imshow(uint8(grad_magnitude));
title('magnitude map');


[angle_size_x,angle_size_y] = size(grad_angle);
%some mathemetical operations to make all the angles positive and making
%them ready for non-maximum spuression
for i = 1:angle_size_x
    for j = 1:angle_size_y
        if (grad_angle(i,j) < 0)
            grad_angle_rectified(i,j) = 360 + grad_angle(i,j);
        else
            grad_angle_rectified(i,j) = grad_angle(i,j);
        end
    end
end

%Non-maximum suppression

gradient_suppressed = zeros(angle_size_x,angle_size_y);

gradient_suppressed(1,:) = 0;
gradient_suppressed(angle_size_x-1,:) = 0;
gradient_suppressed(:,1) = 0;
gradient_suppressed(:,angle_size_y-1) = 0;
%without interpolation
for r= 2: angle_size_x-1
    for c = 2:angle_size_y-1
        
%         if (r == 1) || (r == angle_size_x-1) || (c ==0) || (c == angle_size_y-1)
%             gradient_suppressed(r,c) = 0;
%         end
        
        angle_mod = mod(ceil(grad_angle_rectified(r,c)),4);
        
        if angle_mod == 0
            if (grad_magnitude(r,c) >= grad_magnitude(r,c-1)) && (grad_magnitude(r,c) >= grad_magnitude(r,c+1))
                gradient_suppressed(r,c) = grad_magnitude(r,c);
            end
        end
        
        if angle_mod == 1
            if (grad_magnitude(r,c) >= grad_magnitude(r-1,c+1)) && (grad_magnitude(r,c) >= grad_magnitude(r+1,c-1))
                gradient_suppressed(r,c) = grad_magnitude(r,c);
            end
        end
        if angle_mod == 2
            if (grad_magnitude(r,c) >= grad_magnitude(r-1,c)) && (grad_magnitude(r,c) >= grad_magnitude(r+1,c))
                gradient_suppressed(r,c) = grad_magnitude(r,c);
            end
        end
        if angle_mod == 3
            if (grad_magnitude(r,c) >= grad_magnitude(r-1,c-1)) && (grad_magnitude(r,c) >= grad_magnitude(r+1,c+1))
                gradient_suppressed(r,c) = grad_magnitude(r,c);
            end
        end
    end
end
figure;
imshow(uint8(gradient_suppressed));
title('nonmaximum output without interpolation');
gradient_suppressed = zeros(angle_size_x,angle_size_y);

%interpolation opeartion
for r= 2: angle_size_x-1
    for c = 2:angle_size_y-1
        
%         if (r == 1) || (r == angle_size_x-1) || (c ==0) || (c == angle_size_y-1)
%             gradient_suppressed(r,c) = 0;
%         end
        
        angle_mod = mod(ceil(grad_angle_rectified(r,c)),4);
        
        if angle_mod == 0
            tan_0 = grad_Y_convolve(r,c)/grad_X_convolve(r,c);
           if(grad_magnitude(r,c)>= ((grad_magnitude(r-1,c)*(1-tan_0))) + (grad_magnitude(r-1,c-1)*tan_0)) && ((grad_magnitude(r,c)>= (grad_magnitude(r+1,c)*(1-tan_0)) + (grad_magnitude(r+1,c+1)*tan_0)))
               gradient_suppressed(r,c) = grad_magnitude(r,c);
           else
               gradient_suppressed(r,c) = 0;
           end
           
        end
        
        if angle_mod == 1
            tan_0 = grad_Y_convolve(r,c)/grad_X_convolve(r,c);
           if(grad_magnitude(r,c)>= ((grad_magnitude(r,c-1)*(1-tan_0))) + (grad_magnitude(r-1,c-1)*tan_0)) && ((grad_magnitude(r,c)>= (grad_magnitude(r,c+1)*(1-tan_0)) + (grad_magnitude(r+1,c+1)*tan_0)))
               gradient_suppressed(r,c) = grad_magnitude(r,c);
           else
               gradient_suppressed(r,c) = 0;
           end
        end
        if angle_mod == 2
            tan_0 = grad_Y_convolve(r,c)/grad_X_convolve(r,c);
           if(grad_magnitude(r,c)>= ((grad_magnitude(r,c-1)*(1-tan_0))) + (grad_magnitude(r-1,c+1)*tan_0)) && ((grad_magnitude(r,c)>= (grad_magnitude(r,c+1)*(1-tan_0)) + (grad_magnitude(r+1,c-1)*tan_0)))
               gradient_suppressed(r,c) = grad_magnitude(r,c);
           else
               gradient_suppressed(r,c) = 0;
           end
        end
        if angle_mod == 3
           tan_0 = grad_Y_convolve(r,c)/grad_X_convolve(r,c);
           if(grad_magnitude(r,c)>= ((grad_magnitude(r,c-1)*(1-tan_0))) + (grad_magnitude(r+1,c-1)*tan_0)) && ((grad_magnitude(r,c)>= (grad_magnitude(r,c+1)*(1-tan_0)) + (grad_magnitude(r-1,c+1)*tan_0)))
               gradient_suppressed(r,c) = grad_magnitude(r,c);
           else
               gradient_suppressed(r,c) = 0;
           end
        end
    end
end

figure;
imshow(uint8(gradient_suppressed));
title('nonmaximum output interpolation');

grad_dir1 = zeros(size(gradient_suppressed,1),size(gradient_suppressed,2));
grad_dir2 = zeros(size(gradient_suppressed,1),size(gradient_suppressed,2));
grad_dir3 = zeros(size(gradient_suppressed,1),size(gradient_suppressed,2));
grad_dir4 = zeros(size(gradient_suppressed,1),size(gradient_suppressed,2));

%splitting all the gradient channels for separate color representation 
for r= 2: size(gradient_suppressed,1)-1
    for c = 2:size(gradient_suppressed,2)-1
        

    
        
        if( (grad_angle_rectified(r,c) > 0 && grad_angle_rectified(r,c) < 45)||(grad_angle_rectified(r,c) > 135 && grad_angle_rectified(r,c) < 180))
            grad_dir1(r,c) = gradient_suppressed(r,c);
        end
        
        if ((grad_angle_rectified(r,c) > 45 && grad_angle_rectified(r,c) < 90)||(grad_angle_rectified(r,c) > 270 && grad_angle_rectified(r,c) < 315))
             grad_dir2(r,c) = gradient_suppressed(r,c);
        end
        if ((grad_angle_rectified(r,c) > 90 && grad_angle_rectified(r,c) < 135)||(grad_angle_rectified(r,c) > 225 && grad_angle_rectified(r,c) < 270))
             grad_dir3(r,c) = gradient_suppressed(r,c);
        end
        if ((grad_angle_rectified(r,c) > 135 && grad_angle_rectified(r,c) < 180)||(grad_angle_rectified(r,c) > 315 && grad_angle_rectified(r,c) < 360))
             grad_dir4(r,c) = gradient_suppressed(r,c);
        end
    end
end

            
        
        
        
        
Color_OP1 = zeros(angle_size_x,angle_size_y,3); 
Color_OP2 = zeros(angle_size_x,angle_size_y,3);
Color_OP3 = zeros(angle_size_x,angle_size_y,3);
Color_OP4 = zeros(angle_size_x,angle_size_y,3);
Color_OP5 = ones(angle_size_x,angle_size_y,3);
for r= 2: size(gradient_suppressed,1)-1
    for c = 2:size(gradient_suppressed,2)-1
        Color_OP1(r,c,1) = grad_dir1(r,c);
        Color_OP2(r,c,2) = grad_dir2(r,c);
         Color_OP3(r,c,3) = grad_dir3(r,c);
         Color_OP4(r,c,1) = grad_dir4(r,c);
         Color_OP4(r,c,2) = grad_dir4(r,c);
    end
end

Color_OP = 2*Color_OP1+3*Color_OP2+2*Color_OP3+2*Color_OP4 ;
figure;
imshow(uint8(5*Color_OP))
title('Colored Image')

