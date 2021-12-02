function mahalanobis_distance()
    mu = [3, 4];
    sigma = [1, 0; 0, 2];
    
    points = [10, 10; 0, 0; 3, 4; 6, 8];
    size_points = size(points);
    num_points = size_points(1);
    
    for i=1:num_points
        dist = compute_mahalanobis_distance(points(i, :)', mu', sigma);
        if dist >= 0
            fprintf("mahalanobis dist of (%d, %d) from (%d, %d) is %.3f\n", points(i, 1), points(i, 2), mu(1), mu(2), dist);
        end
    end
end

function maha_dist = compute_mahalanobis_distance(x, mu, sigma)
    rank_sigma = rank(sigma);
    if rank_sigma < min(size(sigma))
        fprintf("entered covariance matrix is singular\n");
        maha_dist = -1;
    else
        sigma_inv = inv(sigma);
        maha_dist = sqrt((x - mu)' * sigma_inv * (x - mu));
    end
end