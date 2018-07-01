for i=1:12
    for j=0:4
        file=sprintf('%s',int2str(i),'/',int2str(i),'_',int2str(j+5),'.bmp');
        face=imread(file);
        for k=1:90
            x=(k-1)*60+1;
            y=k*60;
            B((i-1)*5+1+j,x:y)=double(face(k,:));	% reshape the image into a vector
        end
    end
end

for i = 1 : 60
    B_mean_sub(i,:) =  B(i,:) - avg_face;
end

for i = 1 : 60
    for j = 1 : num_selections+1
        
        dummy1 = B_mean_sub(i,:) * u_vectos(:,j);
        w_t(i,j) = dummy1;
        w_k(i,j) = sub_mean_face_mat(i,:) * u_vectos(:,j);
        
    end
end

for i = 1 : 60
    for j = 1 :12
        
        d_k_bank(i,j) = sum(abs(w_t(i,:) - alpha(j,:)));
        
    end
end

for i =1 : 60
[val,index] = sort(d_k_bank(i,:));
index_output(i,1) = index(1);
index_output(i,2) = index(2);
index_output(i,3) = index(3);
 index_output(i,4) = index(4);

end

flag = 0;
counter = 1;

for i = 1 : 60
    factor_lhs = floor(i/5);
    factor_rhs = ceil(i/5);
    abc = 1 +(5* factor_lhs);
    def = 5 * factor_rhs;
    
    if index_output(i,1) == counter 
       flag = flag + 1;
    elseif index_output(i,2) == counter
       flag = flag + 1;
    elseif index_output(i,3) == counter
       flag = flag + 1;
%     elseif index_output(i,4) == counter
%        flag = flag + 1;
    end
    if mod(i,5) == 0
        counter = counter + 1;
    end
end

per_acc = flag/60*100


    
%  for i=1:20
%   iptsetpref('ImshowBorder','tight');
% 
%   figure
%     imshow(reshape(u_vectos(:,i),60,90)',[])
%   saveas(gcf,['eigenface' num2str(i) '.png']);
% end

