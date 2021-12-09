function hough_for_circles()
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% read the image
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    img = imread('HeadTool0002.bmp');
    img_double = im2double(img);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% apply contrast limited adaptive histogram equalisation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    img_contrast_enhanced = adapthisteq(img_double);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% find circles with radius in some given range
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    radius_min = 20;
    radius_max = 40;
    [centers, radii, metric] = imfindcircles(img_contrast_enhanced,[radius_min radius_max], 'Sensitivity', 0.932);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% show all the detected circles in the enhanced image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(1);
    imshow(img_contrast_enhanced);
    viscircles(centers, radii, 'EdgeColor', 'r');
    title('All circles found');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% find and show 2 strongest circles in the enhanced image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num_strong = 2;
    centers_strong_2 = centers(1:num_strong, :); 
    radii_strong_2 = radii(1:num_strong);
    metric_strong_2 = metric(1:num_strong);
    
    figure(2);
    imshow(img_contrast_enhanced);
    viscircles(centers_strong_2, radii_strong_2, 'EdgeColor', 'r');
    title('Two strongest circles found');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% show accumulutaor array peaks
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('accumulator array peaks\n');
    fprintf('%.4f  ', metric);
    fprintf('\n');
end