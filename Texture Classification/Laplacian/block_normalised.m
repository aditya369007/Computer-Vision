%normalise each block with the max and min values
%go to each block do operation and move to next


% 
% for i = 1 : 59
%     for j = 1 : 100
%         work_space = texture_block_list{i,j};
%         [x_block,y_block] = size(work_space);
%         for k=1:16
%          Nb{:,k} = (work_space(:,k) - Min_Var(k))/(Max_Var(k) - Min_Var(k));
%         end
%     
%             
%                 
%     end
% end

for q = 1 : Texture_Num
    for w = 1 : 100
work_space = texture_block_list{q,w};

for i = 1:size(Max_Var,2)
    
    norm(:,i) = (work_space(i) - Min_Var(i))/(Max_Var(i) - Min_Var(i));
    
end

norm_block{q,w} = norm;
    end
end

%take each block of Ni in each row and calc the eucl distance for each of
%the 100 blocks per row of norm_block

for i = 1 : Texture_Num
    for j = 1 : 100
        a = norm_block{i,j};
        for k = 1 : Texture_Num
            
            b = Ni(k,:);
            %euls_dist(:,k) = sqrt(sum((a-b).^2));
            euls_dist(:,k) = sum(abs(a-b));
        end
        euclid_dist_table{i,j} = euls_dist;
    end
end

%finding the minimum index for the distance and the percent calcualtion


for i = 1 : Texture_Num
    for j = 1 : 100
        
        [min_value_dist, min_index_dist] = min(euclid_dist_table{i,j});
        result_table(i,j) = min_index_dist;
    end
end


for i = 1 : Texture_Num
    for j = 1 : 100
        
        percent(i,:) = sum(result_table(i,:)==i);
    end
end
        

overall_percent = sum(sum(percent))/Texture_Num




