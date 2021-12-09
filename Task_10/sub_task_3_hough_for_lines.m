function sub_task_3_hough_fmor_lines()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Single pixel image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    single_pixel_image = zeros(50);
    single_pixel_image(25, 25) = 255;
    single_pixel_image = cast(single_pixel_image, 'uint8');
    plot_title_single_pixel = 'Original image with single white pixel';
    hough_for_lines(single_pixel_image, 1, plot_title_single_pixel);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 3 Non-aligned points image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    non_aligned_image = zeros(50);
    non_aligned_image(10, 10) = 255;
    non_aligned_image(10, 30) = 255;
    non_aligned_image(30, 10) = 255;
    non_aligned_image = cast(non_aligned_image, 'uint8');
    plot_title_non_aligned = 'Original image with 3 non-aligned white pixels';
    hough_for_lines(non_aligned_image, 2, plot_title_non_aligned);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 3 Aligned points image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    aligned_image = zeros(50);
    aligned_image(10, 10) = 255;
    aligned_image(10, 20) = 255;
    aligned_image(10, 35) = 255;
    aligned_image = cast(aligned_image, 'uint8');
    plot_title_aligned = 'Original image with 3 aligned white pixels';
    hough_for_lines(aligned_image, 3, plot_title_aligned);
end

function hough_for_lines(img, plot_num, plot_title)
    [H, theta, rho] = hough(img);
    figure(plot_num);
    subplot(1, 2, 1);
    imshow(img);
    title(plot_title);
    subplot(1, 2, 2);
    imshow(imadjust(rescale(H)), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
    title('Hough Transform for the image');
    xlabel('\theta')
    ylabel('\rho');
    axis on, axis normal;
    colormap(gca, hot);
end