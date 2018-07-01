

tic

r = VideoWriter('EM_animate_B.avi'); %output vid file name
r.FrameRate = 1; %setting fps
open(r); %opening to begin writing

for i = 1 : size(cluster_book,1)
    for j = 1 : size(cluster_book{i,1})
        
        dumms = cluster_book{i,1}(j,1);
        cluster_fv_master{i,1}(j,:) = fv_pixel_master(dumms,:);
    end
end

d = Num_orien * Num_scale;
EM_2;
close(r);
toc