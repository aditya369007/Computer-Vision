row_blok_size = 64;
col_blok_size = 64;


for i = 1 : Texture_Num
    N = num2str(i);
    Block_Image_List(i,:) = chop_image(Ti{i},row_blok_size,col_blok_size);
end

[x_block,y_block] = size(Block_Image_List);
%I have the list which represents the 100 blocks of each texture
% Need to make the feature vectors for each of the block for all textures

%make 2 loops 1. for each of the 100 blocks 2. for all 59 textures
for i = 1 : x_block
    for j = 1 : y_block

texture_block_list{i,j} = Lap_pyramid(Block_Image_List{i,j},Num_layers,Gau_sigma,Gau_kernel);

    end
end




