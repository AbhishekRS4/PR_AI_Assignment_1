function myhoughline(image, rho, theta_deg)
    theta_rad = deg2rad(theta_deg);
    [height, width] = size(image);
    
    % generic form of hough line is parameterized
    % by the following equation
    % rho = x cos(theta) + y sin(theta)
    
    if theta_deg == 0
        y_1 = 0;
        y_2 = height;
        x_1 = rho;
        x_2 = rho;
    elseif abs(theta_deg) == 90
        x_1 = 0;
        x_2 = width;
        y_1 = rho;
        y_2 = rho;
    elseif ((theta_deg > 0) & (theta_deg < 90))
        x_1 = 0;
        y_2 = 0;
        y_1 = rho / sin(theta_rad);
        x_2 = rho / cos(theta_rad);
    else
        x_1 = 0;
        y_2 = height;
        y_1 = rho / sin(theta_rad);
        x_2 = (rho - (height * sin(theta_rad))) / cos(theta_rad);
    end
    
    figure(1), imshow(image), hold on;
    title(strcat('Hough line with \rho=', num2str(rho), ', \theta=', num2str(theta_deg), ' deg'));
    plot([x_1 x_2], [y_1 y_2], 'LineWidth', 1, 'Color', 'red');
end