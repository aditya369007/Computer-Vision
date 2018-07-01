function [update_probs,updated_mean,update_covar_mat,updated_image1,I,percent_acc_EM]=EM_update(prior_probability,cluster_fv_master,fv_pixel_master,d,random_color,image,gaus_matrix,EM_initial_mean,map_img,iter_count,r)



%we need to find the e-step


for j = 1 : size(fv_pixel_master,1)
    what_sum = 0 ;
    for i =  1 : size(cluster_fv_master,1)
        what_ma = prior_probability(i) * likelihood_fn(fv_pixel_master(j,:),gaus_matrix{i,1},EM_initial_mean(i,:),d);
        what_sum = what_sum + what_ma;
    end
    for k = 1 : size(cluster_fv_master,1)
        I(j,k) = ( prior_probability(k) * likelihood_fn(fv_pixel_master(j,:),gaus_matrix{k,1},EM_initial_mean(k,:),d))/what_sum;
    end
end

% let us find the maximum of each row of the 'I' matrix.
for i = 1 : size(fv_pixel_master,1)
[max_of_I_value, max_of_I_index] = max(I(i,:));
I_max_val(i) = max_of_I_value;
I_max_index(i) = max_of_I_index;
end

I_max_index = I_max_index';
I_max_val = I_max_val';

%forming the image with the obtained clusters
for i = 1 : size(cluster_fv_master,1)
    
    for  j = 1 : size(I_max_index,1)
        
        dummy_point1 = find(I_max_index==i);
        for k = 1 : length(dummy_point1)
            its_show_time1(dummy_point1(k)) = random_color(i);
        end
    end
end
updated_image1 = zeros(size(image,1),size(image,2));
for i = 1 : size(image,1)
    for j = 1 : size(image,2)
        for k = 1 : size(its_show_time1,2)        
        
        updated_image1(k) = its_show_time1(k);
        end
    end
end
figure(2)        
imshow(uint8(updated_image1)')
dum_img = uint8(updated_image1)';
percent_acc_EM = accuracy(map_img,dum_img,iter_count);
saveas(figure(2),sprintf('em.png'))
T = imread('em.png');
writeVideo(r,T);
%after the e step, we come to the M step, which updates the probalitlities
%means and the co-variance matrix
for i = 1 : size(I,2)
update_probs(i) = sum(I(:,i))/size(I,1);
end

%finding the updated mean

for i = 1 :  size(cluster_fv_master,1)
    sum_of_dumms = 0;
    for j = 1 : size(I,1)
        x = fv_pixel_master(j,:);
        y = I(j,i);
        z = x * y;
        sum_of_dumms = sum_of_dumms + z;
    end
    updated_mean(i,:) = sum_of_dumms/sum(I(:,i));
end

%update the covariance matrix
for i = 1 :  size(cluster_fv_master,1)
    
    
    sum_cov = 0;
    
    for j = 1 : size(I,1)
        x1 = I(j,i);
        diff_1 = fv_pixel_master(j,:) - EM_initial_mean(i,:);
        cov1 = x1 * diff_1'*diff_1;
        sum_cov = cov1 + sum_cov;
    end
    den1 = sum_cov/sum(I(:,i));
    update_covar_mat{i,1} = den1;
end


end
