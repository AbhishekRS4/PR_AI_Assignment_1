function [accumulator, thetas_deg, rhos] = myhough(image)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% compute canny edge map for the image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    canny_edge_image = edge(image, 'canny');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% compute the hough space for non-negative distances
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [num_pixels_y, num_pixels_x] = size(image);
    max_dist = cast(round(sqrt(power(num_pixels_x, 2) + power(num_pixels_y, 2))), 'double');
    
    thetas_deg = linspace(0, 90, 181);
    thetas_rad = deg2rad(thetas_deg);
    num_thetas = length(thetas_rad);
    rhos = linspace(0, max_dist, max_dist);
    num_rhos = length(rhos);
    accumulator = zeros(num_rhos, num_thetas);
    
    for y_index = 1:num_pixels_y
        for x_index = 1:num_pixels_x
            if canny_edge_image(y_index, x_index) > 0
                for theta_index = 1:num_thetas
                    r = x_index * cos(thetas_rad(theta_index)) + y_index * sin(thetas_rad(theta_index));
                    rho_index = cast(num_rhos * (r * 1.0) / max_dist, 'int32');
                    accumulator(rho_index, theta_index) = accumulator(rho_index, theta_index) + 1;
                end
            end
        end
    end

    figure(1);
    imshow(imadjust(rescale(accumulator)), 'XData', thetas_deg, 'YData', rhos, 'InitialMagnification', 'fit');
    title('Hough Transform for image');
    xlabel('\theta');
    ylabel('\rho');
    axis on, axis normal;
    colormap(gca, hot);
end