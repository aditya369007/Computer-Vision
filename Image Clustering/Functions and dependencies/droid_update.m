


%loop counter has to initialized incase we need to change the number of k's
%i will be forming a cell matrix which has to contain the distances from
%all the centroid to every point in the feature vector table
function [update_mean,its_show_time,cluster,dist_table_master,percent_acc] = droid_update(image,centroid,norm_fv_master,cent_mat,random_color,map_img,iter_count,v)
loop_counter = size(centroid,2);

for i = 1 : loop_counter
    for j = 1 : size(norm_fv_master,1)
%         dist_table_master(i,j)=sqrt(sum(cent_mat(i,:) - norm_fv_master(j,:)).^2);
dist_table_master(i,j)=sum(abs(cent_mat(i,:) - norm_fv_master(j,:)).^2);
    end
end

%we need to find the minimum of these matrices and find the index

for i = 1 : size(dist_table_master,2)
    
    [data,index] = min(dist_table_master(:,i));
    
    min_dist_data(i,1) = data;
    min_dist_index(i,1) = index;
end

%we have a matrix where the first column denotes the minimum distance, and
%the second column denotes the centroid number where it is closest to, i.e.
%index

%we can now categorize the above obtained matrix into different clusters


for i = 1 : loop_counter
    for  j = 1 : size(min_dist_index,1)
           
         cluster{i,1} = find(min_dist_index== i);
    end
end

%from the above operation we obtain the indicies of each cluster

%i need to form a feature vector table that is labelled by each index of
%the cluster

for i = 1 : loop_counter
    for j = 1 : size(cluster{i,1})
        
        dummy_space = cluster{i,1}(j);
        fvs_of_clusters{i,1}(j,:) = norm_fv_master(dummy_space,:);
    end
end

%let us see where the clusters initaially are

its_show_time = zeros(size(image,1),size(image,2));

for i = 1 : loop_counter
    
    for  j = 1 : size(min_dist_index,1)
        
        dummy_point = find(min_dist_index==i);
        for k = 1 : length(dummy_point)
            its_show_time(dummy_point(k)) = random_color(i);
        end
    end
end
figure(1)        
imshow(uint8(its_show_time)')
dumms_img = uint8(its_show_time)';
percent_acc = accuracy(map_img,dumms_img,iter_count);
saveas(figure(1),sprintf('kmean.png'))
G = imread('kmean.png');
writeVideo(v,G);
% find the mean of each column of the fvs of the clusters

for i = 1 : loop_counter
    for j = 1 : size(fvs_of_clusters{i,1},2)
        update_mean(i,j) = sum(fvs_of_clusters{i,1}(:,j))/size(fvs_of_clusters{i,1},1);
    end
end


end



            
        

