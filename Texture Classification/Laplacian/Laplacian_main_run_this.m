close all
clear
clc
tic
Gau_kernel = 3;
Gau_sigma = 0.37;
Num_layers = 4;
Texture_Num = 59;

Ti = cell(Texture_Num,1);
%Reading all the textures obtaining the feature values
for i = 1 : Texture_Num
    N = num2str(i);
    Ti{i} = imread(['D',N,'.bmp']);
    Fi(i,:) = Lap_pyramid(Ti{i},Num_layers,Gau_sigma,Gau_kernel);
end
%normalising
for i = 1 : 5*Num_layers
    Max_Var(i) = max(Fi(:,i));
    Min_Var(i) = min(Fi(:,i));
    Ni(:,i) = (Fi(:,i) - Min_Var(i))/ (Max_Var(i) - Min_Var(i));
end


image_blocks_list;
block_normalised;
toc