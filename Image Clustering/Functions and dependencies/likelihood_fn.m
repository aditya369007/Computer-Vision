function likely_fn = likelihood_fn (fv_pixel_master,gaus_matrix,EM_initial_mean,d)

num_likely = exp(-0.5 *( fv_pixel_master - EM_initial_mean)  * inv(gaus_matrix) * (fv_pixel_master-EM_initial_mean)');
den_likely = (2 * pi)^(d/2) * sqrt(det(gaus_matrix));
likely_fn = num_likely/den_likely;

end