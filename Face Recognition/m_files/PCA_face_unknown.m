test_img_f = imread('trump.jpg');
img_f_bw = rgb2gray(test_img_f);
img_f_bw = (imresize(img_f_bw,[90,60]));
img_vec_f = double(img_f_bw(:));
figure
imshow(img_f_bw)
img_vec_f = img_vec_f';

 img_mean_sub_f = img_vec_f - avg_face;
 
 counter = 1;
for p = 5400: -1: 5400-num_selections
    
  beta_f(counter)= img_mean_sub_f * V(:,p);
  counter = counter +1 ;
end
 
sum_1_f = 0;
for i = 1 : num_selections+1
    recon_nf = beta_f(i) * u_vectos(:,i);
    sum_1_f = sum_1_f + recon_nf;
    reco_img_f = sum_1_f + avg_face';

figure(7);
imshow(reshape(reco_img_f,60,90)',[])
img_rcon_error_f(i) = sum(abs(img_vec_f - reco_img_f'));
figure(8)
plot(img_rcon_error_f)


end




 