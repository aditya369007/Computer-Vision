EM_initial_mean = a;
%calculation of prior probability from the values obtained via K means
for i = 1 : size(cluster_fv_master,1)
    prior_probability(i) = size(cluster_fv_master{i,1},1)/size(fv_pixel_master,1);
end

%next step in the algorithm would be the initilization of gaussian models
%covariance matrix
for i = 1 : size(cluster_fv_master,1)
    gauss_sum = 0;
    for j = 1 : size(cluster_fv_master{i,1},1)
        
        mean_diff = (cluster_fv_master{i,1}(j,:)) - EM_initial_mean(i,:);
        mean_mult = mean_diff' * mean_diff;
        gauss_sum = gauss_sum + mean_mult;
        
        
        
    end
    gaus_matrix{i,:} = gauss_sum/size(cluster_fv_master{i,1},1);
end
figure(2)
imshow(uint8(b)');
saveas(figure(2),sprintf('em.png'))
T = imread('em.png');
writeVideo(r,T);
%we need to find the e-step
d = Num_orien * Num_scale;
% what_ma = (prior_probability(1) * likelihood_fn(fv_pixel_master(2,:),gaus_matrix{1,1},EM_initial_mean(1,:),d)) + (prior_probability(2) * likelihood_fn(fv_pixel_master(2,:),gaus_matrix{2,1},EM_initial_mean(2,:),d)) + (prior_probability(3) * likelihood_fn(fv_pixel_master(2,:),gaus_matrix{3,1},EM_initial_mean(3,:),d));
% I = prior_probability(2) * likelihood_fn(fv_pixel_master(2,:),gaus_matrix{2,1},EM_initial_mean(2,:),d) / what_ma;

for i = 1 : 5
    
    [prob1,mean1,covar1,image_up,likelyfn_m,percent_acc_EM] = EM_update(prior_probability,cluster_fv_master,fv_pixel_master,d,random_color,image,gaus_matrix,EM_initial_mean,map_img,i,r);
    
    EM_sum_overall = 0;
    for j = 1 : size(fv_pixel_master,1)
        EM_sum_indi = 0;
        for l = 1 : size(prior_probability,1)
            EM_dist_fn =  likelyfn_m(j,l) * prior_probability(l);
            EM_sum_indi = EM_sum_indi + EM_dist_fn;
        end
        EM_sum_indi = log(EM_sum_indi);
        EM_sum_overall = EM_sum_indi + EM_sum_overall;
    end
    EM_sum_tble(i) = EM_sum_overall;
    per_EM_table(i) = percent_acc_EM;
    prior_probability = prob1;
    EM_initial_mean = mean1;
    gaus_matrix = covar1;
    i
end
figure('Name','EM obj fn');
plot(EM_sum_tble);
figure('Name','EM per acc');
plot(per_EM_table);

