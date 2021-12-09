function hough_for_lines()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Single pixel image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    single_pixel_image = zeros(50);
    single_pixel_image(25, 25) = 255;
    single_pixel_image = cast(single_pixel_image, 'uint8');
    plot_title_single_pixel = 'Original image with single white pixel';
    compute_hough_for_lines(single_pixel_image, 1, plot_title_single_pixel, 0);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 3 Non-aligned points image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    non_aligned_image = zeros(50);
    non_aligned_image(10, 10) = 255;
    non_aligned_image(10, 30) = 255;
    non_aligned_image(30, 10) = 255;
    non_aligned_image = cast(non_aligned_image, 'uint8');
    plot_title_non_aligned = 'Original image with 3 non-aligned white pixels';
    compute_hough_for_lines(non_aligned_image, 2, plot_title_non_aligned, 0);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 3 Aligned points image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    aligned_image = zeros(50);
    aligned_image(10, 10) = 255;
    aligned_image(10, 20) = 255;
    aligned_image(10, 35) = 255;
    aligned_image = cast(aligned_image, 'uint8');
    plot_title_aligned = 'Original image with 3 aligned white pixels';
    compute_hough_for_lines(aligned_image, 3, plot_title_aligned, 1);
end

function compute_hough_for_lines(img, plot_num, plot_title, show_peaks)
    [H, theta, rho] = hough(img);
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
    
    if show_peaks == 1
        peaks = houghpeaks(H, 1);
        figure(plot_num + 1);
        imshow(H, [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
        title('One strongest maxima for image');
        xlabel('\theta');
        ylabel('\rho');
        axis on, axis normal, hold on;
        colormap(gca, hot);
        x = theta(peaks(:, 2)); y = rho(peaks(:, 1));
        plot(x, y, 's', 'color', 'white');
        
        myhougline(img, theta, rho, peaks, plot_num);
    end
end

function myhougline(img, theta, rho, peaks, plot_num)
    lines = houghlines(img, theta, rho, peaks, 'MinLength', 1);
    figure(plot_num + 2), imshow(img), hold on;
    title('Image overlaid with strongest line');
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