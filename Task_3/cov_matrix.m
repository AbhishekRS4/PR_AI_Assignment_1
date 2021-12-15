% 1
feature_vector = [4 5 6; 6 3 9; 8 7 3; 7 4 8; 4 6 5];
% calculate the means by column
means = mean(feature_vector, 1);
disp(means);

% fill the covariance matrix with 0
cov_matri = zeros(size(feature_vector, 2), size(feature_vector, 2));

for idx = 1:size(feature_vector, 2) % index of the first feature
    for jdx = 1:size(feature_vector, 2) % index of the second feature
        cov_feature = 0;
        for row = 1:size(feature_vector, 1) 
            cov_feature = cov_feature + (feature_vector(row, idx) - means(idx))*(feature_vector(row, jdx) - means(jdx));
        end
        % since we don't have a sample here, we divide the sum by the size
        % of the feature vector without subtracting one
        cov_matri(idx, jdx) = cov_feature/(size(feature_vector, 1));
    end    
end    
disp(cov_matri);
    
% 2
points = [5 5 6; 3 5 7; 4 6.5 1];
% the function mvnpdf calculates the probability density of a point given
% a mean and a covariance matrix
disp(round(mvnpdf(points, means, cov_matri), 6));