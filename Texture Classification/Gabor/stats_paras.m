function Feature_Vec_form = stats_paras(Image)

    num_elements = size(Image,1) * size(Image,2);
    sum_ele = sum(sum(Image));
    mean_ele =sum_ele/num_elements;
    
    var_dummy = ((Image - mean_ele).^2) / (num_elements - 1);
     var_ele = sum(sum(var_dummy));
    
    std_dev = sqrt(var_ele);
    
    skew_dummy = ((Image - mean_ele).^3) / ((num_elements - 1) * std_dev^3);
    skew_ele = sum(sum(skew_dummy));
    
    kurt_dummy = ((Image - mean_ele).^4) / ((num_elements - 1) * std_dev^4);
    kurt_ele = sum(sum(kurt_dummy));
    std_dev_ele = sum(sum(std_dev));
 
 for i = 1 : 2
%     if i ==1
%         Featurevector(i,:) = (mean_ele);
%     end
    if i == 1
        Featurevector(i,:) = (var_ele);
    end
%     if i == 1
%         Featurevector(i,:) =(skew_ele);
%     end
%     if i == 1
%         Featurevector(i,:) = (kurt_ele);
%     end
    if i == 2
        Featurevector(i,:) = (std_dev);

    
    end
 
    Feature_Vec_form = Featurevector(:)';
end