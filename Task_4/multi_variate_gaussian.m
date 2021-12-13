function multi_variate_gaussian()
    mu = [3, 4]';
    sigma = [1, 0; 0, 2];
    
    generate_multi_variate_gaussian(mu, sigma);
end

function generate_multi_variate_gaussian(mu, sigma)
    x = linspace(-10, 10);
    y = linspace(-10, 10);
    [xx, yy] = meshgrid(x, y);
    z = mvnpdf([xx(:) yy(:)], mu', sigma);
    z = reshape(z, size(xx));
    mesh(xx, yy, z);
    title("2D Gaussian PDF");
    xlabel("x_1");
    ylabel("x_2");
end