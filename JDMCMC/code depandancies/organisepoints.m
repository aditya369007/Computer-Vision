function Output = organisepoints(S)
sample_size = size(S, 3);%number of samples
Output = S;
for i = 1:sample_size
    Si = S(:,:,i);
    Si = reshape(Si, 2, []);
    D = Si(1, :).^2 + Si(2,:).^2;
    [~,IX] = sort(D,'ascend');
    Si = Si(:, IX);
    Si = reshape(Si, [], 2);
    Output(:,:,i) = Si;
end
end