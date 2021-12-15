x=importdata('task_1.mat','headerlines',1);

% calculate the average for each feature
average_height = mean(x(:,1)); 
average_age = mean(x(:,2));
average_weight = mean(x(:,3));

length = size(x);
disp(length(1));

sum_height_age = 0;
sum_height_weight = 0;
sum_age_weight = 0;

for idx = 1:size(x,1)
    % height - age
    sum_height_age = sum_height_age + (x(idx,1) - average_height)*(x(idx,2) - average_age);
    
    % height - weight
    sum_height_weight = sum_height_weight + (x(idx,1) - average_height)*(x(idx,3) - average_weight);
    
    % age - weight
    sum_age_weight = sum_age_weight + (x(idx,2) - average_age)*(x(idx,3) - average_weight);
end

cov_height_age = sum_height_age/(length(1) - 1);
cov_height_weight = sum_height_weight/(length(1) - 1);
cov_age_weight = sum_age_weight/(length(1) - 1);

sd_height = std(x(:,1));
sd_age = std(x(:,2));
sd_weight = std(x(:,3));

cor_height_age = cov_height_age/(sd_height*sd_age);
cor_height_weight = cov_height_weight/(sd_height*sd_weight);
cor_age_weight = cov_age_weight/(sd_age*sd_weight);

disp(cor_height_age);
disp(cor_height_weight);
disp(cor_age_weight);

figure
scatter(x(:,1), x(:,3))
title("Scatterplot of Height vs Weight")
xlabel("Height");
ylabel("Weight");

figure
scatter(x(:,2), x(:,3))
title("Scatterplot of Age vs Weight")
xlabel("Age");
ylabel("Weight");


