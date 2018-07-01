function Feature_Vec_form = Lap_pyramid(img,Num_layers,Gau_Sigma,Gau_kernel)



for i= 1 : Num_layers 

    if i == 1
        Gauss_py_layer{1} = img;
    else    
    Gauss_py_layer{i} = gauss_blur(Gauss_py_layer{i-1},Gau_kernel,Gau_Sigma);
    end
    
end

for i = Num_layers : -1 : 1
    
    if i == Num_layers
        Lap_py_layer{1} = cell2mat(Gauss_py_layer(Num_layers));
    else
        dummy = cell2mat(Gauss_py_layer(i + 1));
        dummy = imresize(dummy,2,'bilinear');
        Lap_py_layer{Num_layers - i + 1} = double(cell2mat(Gauss_py_layer(i ))) - dummy ;
    end
        
    
end

for i = 1 : Num_layers
    
    num_elements = size(cell2mat(Lap_py_layer(i)),1) * size(cell2mat(Lap_py_layer(i)),2);
    sum_ele = sum(sum(cell2mat(Lap_py_layer(i))));
    mean_ele{i} =sum_ele/num_elements;

end

for i = 1 : Num_layers
    
    num_elements = size(cell2mat(Lap_py_layer(i)),1) * size(cell2mat(Lap_py_layer(i)),2);
    mean_dummy = cell2mat(mean_ele(i));
    Lap_dummy = cell2mat(Lap_py_layer(i));
    var_dummy = ((Lap_dummy - mean_dummy).^2) / (num_elements - 1);
     var_ele{i} = sum(sum(var_dummy));
    
end

for i = 1 : Num_layers
     num_elements = size(cell2mat(Lap_py_layer(i)),1) * size(cell2mat(Lap_py_layer(i)),2);
    mean_dummy = cell2mat(mean_ele(i));
    Lap_dummy = cell2mat(Lap_py_layer(i));
    var_dummy = cell2mat(var_ele(i));
    std_dev = sqrt(var_dummy);
    
    skew_dummy = ((Lap_dummy - mean_dummy).^3) / ((num_elements - 1) * std_dev^3);
    skew_ele{i} = sum(sum(skew_dummy));
end
    
for i = 1 : Num_layers
     num_elements = size(cell2mat(Lap_py_layer(i)),1) * size(cell2mat(Lap_py_layer(i)),2);
    mean_dummy = cell2mat(mean_ele(i));
    Lap_dummy = cell2mat(Lap_py_layer(i));
    var_dummy = cell2mat(var_ele(i));
    std_dev = sqrt(var_dummy);
    
    kurt_dummy = ((Lap_dummy - mean_dummy).^4) / ((num_elements - 1) * std_dev^4);
    kurt_ele{i} = sum(sum(kurt_dummy));
    std_dev_ele{i} = sum(sum(std_dev));
end   

for i = 1 : 5
    if i ==1
        Featurevector(i,:) = cell2mat(mean_ele);
    end
    if i == 2
        Featurevector(i,:) = cell2mat(var_ele);
    end
    if i == 3
        Featurevector(i,:) = cell2mat(skew_ele);
    end
    if i == 4
        Featurevector(i,:) = cell2mat(kurt_ele);
    end
    if i == 5
        Featurevector(i,:) = cell2mat(std_dev_ele);
    end
    
end
        

Feature_Vec_form = Featurevector(:)';
end
        
    
