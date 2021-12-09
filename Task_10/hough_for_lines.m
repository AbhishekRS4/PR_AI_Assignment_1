function hough_for_lines()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Single pixel image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    single_pixel_image = zeros(50);
    single_pixel_image(25, 25) = 255;
    single_pixel_image = cast(single_pixel_image, 'uint8');
    
    [H_1, theta_1, rho_1] = compute_hough_for_lines(single_pixel_image);
    
    plot_title_single_pixel = 'Image with single white pixel';
    plot_hough_space(1, plot_title_single_pixel, H_1, theta_1, rho_1, single_pixel_image);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 3 Non-aligned points image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    non_aligned_image = zeros(50);
    non_aligned_image(10, 10) = 255;
    non_aligned_image(10, 30) = 255;
    non_aligned_image(30, 10) = 255;
    non_aligned_image = cast(non_aligned_image, 'uint8');
    
    [H_2, theta_2, rho_2] = compute_hough_for_lines(non_aligned_image);
    
    plot_title_non_aligned = 'Image with 3 non-aligned white pixels';
    plot_hough_space(2, plot_title_non_aligned, H_2, theta_2, rho_2, non_aligned_image);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 3 Aligned points image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    aligned_image = zeros(50);
    aligned_image(10, 10) = 255;
    aligned_image(10, 20) = 255;
    aligned_image(10, 35) = 255;
    aligned_image = cast(aligned_image, 'uint8');
    
    [H_3, theta_3, rho_3] = compute_hough_for_lines(aligned_image);
    
    plot_title_aligned = 'Image with 3 aligned white pixels';
    plot_hough_space(3, plot_title_aligned, H_3, theta_3, rho_3, aligned_image);
    
    num_peaks = 1;
    peaks = compute_hough_peaks(H_3, num_peaks);
    
    plot_title_peaks = 'One strongest maxima for image with 3 aligned white pixels';
    plot_hough_space_with_peaks(4, plot_title_peaks, H_3, theta_3, rho_3, peaks);
    
    plot_title_overlay = 'Image with 3 aligned white pixels overlaid with strongest line';
    draw_hough_line(5, plot_title_overlay, aligned_image, theta_3, rho_3, peaks);
end

function [H, theta, rho] = compute_hough_for_lines(img)
    [H, theta, rho] = hough(img);
end

function peaks = compute_hough_peaks(H, num_peaks)
    peaks = houghpeaks(H, num_peaks);
end

function plot_hough_space(plot_num, plot_title, H, theta, rho, img)
    figure(plot_num);
    subplot(1, 2, 1);
    imshow(img);
    title(plot_title);
    subplot(1, 2, 2);
    imshow(imadjust(rescale(H)), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
    title('Hough Transform for the image');
    xlabel('\theta');
    ylabel('\rho');
    axis on, axis normal;
    colormap(gca, hot);
end

function plot_hough_space_with_peaks(plot_num, plot_title, H, theta, rho, peaks)
    figure(plot_num);
    imshow(H, [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
    title(plot_title);
    xlabel('\theta');
    ylabel('\rho');
    axis on, axis normal, hold on;
    colormap(gca, hot);
    x = theta(peaks(:, 2)); y = rho(peaks(:, 1));
    plot(x, y, 's', 'color', 'white');
end

function draw_hough_line(plot_num, plot_title, img, theta, rho, peaks)
    lines = houghlines(img, theta, rho, peaks, 'MinLength', 1);
    figure(plot_num), imshow(img), hold on;
    title(plot_title);
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:, 1), xy(:, 2), 'LineWidth', 1, 'Color', 'green');

       % Plot beginnings and ends of lines
       plot(xy(1, 1), xy(1, 2), 'x', 'LineWidth', 1, 'Color', 'yellow');
       plot(xy(2, 1), xy(2, 2), 'x', 'LineWidth', 1, 'Color', 'red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if (len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
end