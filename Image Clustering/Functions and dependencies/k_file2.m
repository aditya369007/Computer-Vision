tic
close all
for q = 1 : 5
[a,b,cluster_book,dist_op,p_acc] = droid_update(image,centroid,fv_pixel_master,cent_mat,random_color,map_img,q,v);


dist_tble(q) = sum(sum(dist_op));
per_table(q) = p_acc;
cent_mat = a;
q
end
figure('Name','K means obj');
plot(dist_tble);
figure('Name','P Acc K means');
plot(per_table);


toc