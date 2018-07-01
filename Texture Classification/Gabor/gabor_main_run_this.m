
clear all;

tic
Num_scale=4;
Num_orien=6;
Texture_Num = 59;
texture=cell(Texture_Num,1);
%form a table which has all the outputs of gobol filter outputs of each
%image
for i = 1 : Texture_Num
    N = num2str(i);
    texture{i}  = imread(['D',N,'.bmp']);
    E0=gaborconvolve(texture{i},Num_scale,Num_orien,3,2,0.65,1.5);
    for k = 1:Num_scale
        for j = 1 : Num_orien
            E_mag{k,j} = abs(E0{k,j});
        end
    end
    E_mag1 = E_mag(:)';
    E_mag_table(i,:) = E_mag1;
end


my_gabor;
gabol_small_blocks;


toc