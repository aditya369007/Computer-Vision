% now that i have table with all gabor outputs, extract feature vectors
% form each output of the gabor filter.

for i = 1 : size(E_mag_table,1)
    for j = 1 : size(E_mag_table,2)

Y(i,:) = (stats_paras(E_mag_table{i,j}));
Gobor_feature_table{i,j}=Y(i,:);
 
    end
end

%after the formation of the feature table, now it has to be normalised
for i = 1 : size(E_mag_table,1)
Gob_table_mat(i,:) = horzcat(Gobor_feature_table{i,:});

end

for i = 1 : size(Gob_table_mat,2)
    
    Max_var(i) = max(Gob_table_mat(:,i));
    Min_var(i) = min(Gob_table_mat(:,i));
    Norm_gobol_mat(:,i) = (Gob_table_mat(:,i) - Min_var(i))/(Max_var(i) - Min_var(i));
end




