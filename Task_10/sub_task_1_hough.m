function sub_task_1_hough()
    img = imread('Cameraman.tiff');
    % display(size(img));
    figure(1);
    imshow(img);
    title("Original Cameraman image");
    %pause(2);
    
    canny_edge_map = edge(img, 'canny');
    figure(2);
    imshow(canny_edge_map);
    title("Canny edge detection output for Cameraman image");
    %pause(2);
    
    [H, theta, rho] = hough(canny_edge_map);
    figure(3);
    imshow(imadjust(rescale(H)), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
    title('Hough Transform for Cameraman image');
    xlabel('\theta')
    ylabel('\rho');
    axis on, axis normal;
    colormap(gca, hot);
    
    %fprintf('min H : %d\n', min(H));
    %fprintf('max H : %d\n', max(H));
    
    threshold = 20;
    H_threshold_true = (H >= threshold);
    H_thresholded = H .* H_threshold_true;
    
    %fprintf('min H : %d\n', min(H_thresholded));
    %fprintf('max H : %d\n', max(H_thresholded));
    %display(size(H));
    %display(size(H_thresholded));
    
    figure(4);
    imshow(imadjust(rescale(H_thresholded)), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
    title('Thresholded Hough Transform for Cameraman image');
    xlabel('\theta')
    ylabel('\rho');
    axis on, axis normal;
    colormap(gca, hot);
    
    peaks = houghpeaks(H_thresholded, 5);
    figure(5);
    imshow(H_thresholded, [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
    title('Thresholded Hough Transform with 5 strongest local maxima for Cameraman image');
    xlabel('\theta')
    ylabel('\rho');
    axis on, axis normal, hold on;
    colormap(gca, hot);
    x = theta(peaks(:, 2)); y = rho(peaks(:, 1));
    plot(x, y, 's', 'color', 'white');
    
    myhougline(img, theta, rho, peaks);
end

function myhougline(img, theta, rho, peaks)
    lines = houghlines(img, theta, rho, peaks, 'FillGap', 5, 'MinLength', 7);
    figure(6), imshow(img), hold on;
    title('Cameraman image overlaid with lines');
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:, 1), xy(:, 2), 'LineWidth', 2, 'Color', 'green');

       % Plot beginnings and ends of lines
       plot(xy(1, 1), xy(1, 2), 'x', 'LineWidth', 2, 'Color', 'yellow');
       plot(xy(2, 1), xy(2, 2), 'x', 'LineWidth', 2, 'Color', 'red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if (len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
end