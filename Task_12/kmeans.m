clear all;
load kmeans1.mat;
load checkerboard.mat;

% settings
K=2;
data = kmeans1;
% data = checkerboard;
Kmeansplusplus = false;
if K > 8
    plotFlag = false;
else
    plotFlag = true;
end


% initialization

% determine range
[maxval, ~] = max(abs(data));
if Kmeansplusplus == false % initialize K means randomly
    means = zeros(K, 2);
    for i=1:K
        means(i, 1) = (rand - 0.5) * 2 * maxval(1);
        means(i, 2) = (rand - 0.5) * 2 * maxval(2);
    end
else % initialize according to Kmeans++
    randomIndex = round(length(data) * rand);
    means = zeros(1, 2);
    means(1, :) = data(randomIndex, :);
    
    for j=2:K
        distances = zeros(length(data), 1);
        for i=1:length(data) 
            [distances(i), ~] = nearestNeighbor(data(i,:), means, length(means(:, 1)));
            distances(i) = distances(i)^2 * rand;
        end
        [distance, index] = max(distances);
        means(j, :) = data(index, :);
    end
end
    
    
% run loop
labels = zeros(length(data), 1);
change = true;

counter = 0;
while change
    counter = counter + 1;
    historicalMeans(:, :, counter) = means;
    oldLabels = labels;
    for i=1:length(data)
        [~, labels(i)] = nearestNeighbor(data(i, :), means, K);
    end
    if oldLabels == labels
        change = false;
    end
    means = update(data, labels, means, K);
end


% quantizationError = calcQuantizationError(data, means)

quantizationError = 0;
for i=1:length(data)
    quantizationError = quantizationError + sum((data(i, :)-means(labels(i), :)).^2);
end
quantizationError


if plotFlag == true
    % plot results
    t = tiledlayout(1, 2);
    colors = {'o', '+', '*', 'd', 's', 'x', '.', 'v'};
    X = data(:, 1);
    Y = data(:, 2);
    nexttile;
    hold on;
    for i =1:K
        plot(X(labels == i), Y(labels == i), colors{i});
    end
    plot(means(:, 1), means (:, 2), 'kp');

    nexttile;
    hold on;
    for i=1:K
        for j=1:(counter-1)
            plot_arrow(historicalMeans(i,1,j), historicalMeans(i,2,j) ,historicalMeans(i,1,j+1), historicalMeans(i,2,j+1));
        end
    end
    plot(means(:, 1), means (:, 2), 'kp');
    % axis([-6 8 -4 3]);
    % exportgraphics(t,'12-1-8.pdf')
end



% return nearest neighbor class index
function [distance, class] = nearestNeighbor(coords, means, K)
    distance_table = (1:K);
    for i = 1:K
        distance_table(i) = sqrt(sum((means(i, :)-coords).^2));
    end
    sorted_labels = sortrows(distance_table);
    [distance, class] = min(distance_table);
end
    
% recalculate the K means
function newMeans = update(data, labels, means, K)
    newMeans = zeros(K, 2);
    n = zeros(K);

    for i = 1:length(data)
        newMeans(labels(i), :) = newMeans(labels(i), :) + data(i, :);
        n(labels(i)) = n(labels(i)) + 1;
    end
    for i = 1:length(n)
        newMeans(i, :) = newMeans(i, :) / n(i);
    end
end



