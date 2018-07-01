%reconstruct 1st person 2nd img
img = A(19,:);
img_t = img - avg_face;
counter = 1;
for p = 5400: -1: 5400-num_selections
    
  beta(counter)= img_t * V(:,p);
  counter = counter +1 ;
end


counter = 1;
for p = 5400: -1: 5400-num_selections
u_vectos(:,counter) = V(:,p);
counter = counter + 1;
end

sum_1 = 0;
for i = 1 : num_selections+1
    recon = beta(i) * u_vectos(:,i);
    sum_1 = sum_1 + recon;
    reco_img = sum_1 + avg_face';
figure(3);
imshow(reshape(reco_img,60,90)',[])
img_rcon_error(i) = sum(abs(img - reco_img'));

end
figure(4)
plot(img_rcon_error)
    


