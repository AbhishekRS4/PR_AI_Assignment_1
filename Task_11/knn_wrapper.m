clear all;
load task_11.mat;

K=7;
samples=64;
data = task_11;
nr_of_classes = 4;


% Class labels
class_labels = floor( (0:length(data)-1) * nr_of_classes / length(data) );
disp(class_labels);
% Sample the parameter space
result=zeros(samples);
for i=1:samples
  X=(i-1/2)/samples;
  for j=1:samples
    Y=(j-1/2)/samples;
    result(j,i) = KNN([X Y],K,data,class_labels);
  end;
end;

% result(j,i) = KNN([0 0],K,data,class_labels);

% Show the results in a figure
imshow(result,[0 nr_of_classes-1],'InitialMagnification','fit')
hold on;
title([int2str(K) '-NN, ' int2str(nr_of_classes) ' classes']);

% this is only correct for the first question
scaled_data=samples*data;
plot(scaled_data(  1:50,1),scaled_data(  1:50,2),'go');
plot(scaled_data(  51:100,1),scaled_data(  51:100,2),'y*');
plot(scaled_data(101:150,1),scaled_data(101:150,2),'r+');
plot(scaled_data(151:200,1),scaled_data(151:200,2),'bd');



% score = leave_one_out_cross_validation(data, class_labels, K);
% disp(score);

maxScore = 0;
maxK = 0;
for k=1:2:25
    score = leave_one_out_cross_validation(data, class_labels, k);
    disp([k score]);
    if score > maxScore
        maxScore = score;
        maxK = k;
    end
end
disp([maxScore maxK]);

% KNN function
function class = KNN(coords, K, data, class_labels)
    distance_table = zeros(length(data), 2);
    for i = 1:length(data)
        distance_table(i, 1) = sqrt(sum((data(i, :)-coords).^2));
        distance_table(i, 2) = class_labels(i);
    end
    sorted_labels = sortrows(distance_table);
    K_neighbor_labels = sorted_labels(1:K, 2);
    [class, ~] = mode(K_neighbor_labels);
end

% leave-one-out cross-validation function
function score = leave_one_out_cross_validation(data, class_labels, K)
    score = 0;
    for i=1:length(class_labels)
       data_copy = data;
       data_copy(i, :) = [];
       class_labels_copy = class_labels;
       class_labels_copy(i) = [];
       label = KNN(data(i, :), K, data_copy, class_labels_copy);
       if label == class_labels(i)
           score = score + (1/(length(class_labels)-1));
       end
    end
end
