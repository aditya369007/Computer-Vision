function [Mxy] = gibbs_sampling(img, target, M,vid)

Ts = 100;
K_MAX = 300;
[rows,cols] = size(img);

Oxy_now = zeros(M, 2, Ts);
Oxy_now(:,:,1) = [randi(rows, M, 1) randi(cols, M, 1)];
Oxy_new = Oxy_now(:,:,1);

showImg = drawcircle(img, Oxy_new, M);  
figure(1); imshow(showImg);


L1 = likelihood(img, target, Oxy_new, M);
for t = 2:Ts
    for i = 1:M        
       
        Oxy = Oxy_new(2*i-1:2*i);
        for j = 1:K_MAX            
            Dxy = Oxy + round(randn(1,2)*20);
            Dxy=clip(Dxy,1,rows);
            New_Cur_Oxy = Oxy_new;
            New_Cur_Oxy(2*i-1:2*i) = Dxy;
            L2=likelihood(img,target,New_Cur_Oxy,M);
            v=min(1,L2/L1);                    
            u=rand;                             
            if v>u                
                Oxy = Dxy;                   
                Oxy_new = New_Cur_Oxy;
                L1 = L2;                

            else                       
            end            
        end
        Oxy_now(:,:, t) = Oxy_new;       
        showImg = drawcircle(img, Oxy_new, M);
        figure(1); imshow(showImg);


    end
end

Mxy = Oxy_new;
showImg = drawcircle(img, Mxy, M);figure(1);imshow(showImg);
writeVideo(vid,showImg);


end
