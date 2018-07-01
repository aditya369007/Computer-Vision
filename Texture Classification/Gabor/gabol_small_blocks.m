row_blok_size = 64;
col_blok_size = 64;

%forming the samll images for recognition
for i = 1 : Texture_Num
   
    Block_Image_Gabol(i,:) = chop_image(texture{i},row_blok_size,col_blok_size);
end

%obtaining the parameters of gobol
for i=1:Texture_Num
    for j=1:100

            Chop_gabol_conv_1=gaborconvolve(Block_Image_Gabol{i,j},Num_scale,Num_orien,3,2,0.65,1.5);
             for k=1:Num_scale
                for l=1:Num_orien
                    Chop_mag_1{k,l}=abs(Chop_gabol_conv_1{k,l});
                end
             end
             A=Chop_mag_1(:)';
            Chop_mag1_1(i,:)=A;
            Chop_mag_table_1{i,j}=Chop_mag1_1(i,:);
    end
end

%feature vectors for all
for i = 1 : size(Block_Image_Gabol,1)
    for j = 1 : size(Block_Image_Gabol,2)
        for k = 1 : 24
        Block_gabol_feature_1_new{1,k} = (stats_paras(Chop_mag_table_1{i,j}{1,k}));
        

%         wec_hbl = Block_gabol_feature_1;
        end
%   
        Vector_block_new = horzcat(Block_gabol_feature_1_new{:});
        Vec_blk_new{i,j} = Vector_block_new;
%         Vec_blk{i,j} = wec_hbl(:,1);
    end
end

for i = 1 : size(Vec_blk_new,1)
    for j = 1 : size(Vec_blk_new,2)
        for k = 1 : size(Vector_block_new,2)
    Norm_f_new(1,k) = (Vec_blk_new{i,j}(k) - Min_var(k))/(Max_var(k) - Min_var(k));
        end
        Norm_finale_new{i,j} = Norm_f_new;
    end
end
%formation of the distance
for i = 1 : size(Norm_finale_new,1)
    for j = 1 : size(Norm_finale_new,2)
yy = Norm_finale_new{i,j};
for k = 1 : size(Norm_gobol_mat,1)
xx = Norm_gobol_mat(k,:);

dist_new(:,k) = sum(abs(xx-yy));
end
dist_table_new{i,j} = dist_new;
    end
end
%obtaining the overall percentage list
for i = 1 : 59
    for j = 1 : 100
      [minim_new,index_new] = min(dist_table_new{i,j});  
         list_final_new(i,j)=index_new;
    end
end
for i = 1 : Texture_Num
    for j = 1 : 100
        
        percent_new(i,:) = sum(list_final_new(i,:)==i);
    end
end
overall_percent_new = sum(sum(percent_new))/Texture_Num

