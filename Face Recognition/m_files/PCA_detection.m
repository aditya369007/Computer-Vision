test_img_nf = imread('velo.png');
img_nf_bw = rgb2gray(test_img_nf);
img_nf_bw = (imresize(img_nf_bw,[90,60]));
img_vec = double(img_nf_bw(:));
figure
imshow(img_nf_bw)
img_vec = img_vec';

 img_mean_sub_nf = img_vec - avg_face;
 
 counter = 1;
for p = 5400: -1: 5400-num_selections
    
  beta_nf(counter)= img_mean_sub_nf * V(:,p);
  counter = counter +1 ;
end
 
sum_1_nf = 0;
for i = 1 : num_selections+1
    recon_nf = beta_nf(i) * u_vectos(:,i);
    sum_1_nf = sum_1_nf + recon_nf;
    reco_img_nf = sum_1_nf + avg_face';

figure(5);
imshow(reshape(reco_img_nf,60,90)',[])
img_rcon_error_nf(i) = sum(abs(img_vec - reco_img_nf'));
figure(6)
plot(img_rcon_error_nf)


end




 