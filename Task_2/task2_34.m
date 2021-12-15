% calculate the variance and the mean
SHD_var = var(SH_distances);
SHD_mean = mean(SH_distances);

DHD_var = var(DH_distances);
DHD_mean = mean(DH_distances);

fprintf('SHD var: %d, mean: %d\n', SHD_var, SHD_mean);
fprintf('DHD var: %d, mean: %d\n', DHD_var, DHD_mean);

% generate the normal distibutons
distances = 0:0.01:1;
SHD_dist = normpdf(distances, SHD_mean, sqrt(var(SH_distances)));
DHD_dist = normpdf(distances, DHD_mean, sqrt(var(DH_distances)));
% we scale the normal distribution by multiplying the values by the bin 
% width and the number of samples
SHD_dist = SHD_dist*0.03*1000;
DHD_dist = DHD_dist*0.03*1000;

% add the distributions to the histogram
histogram(SH_distances, 'BinWidth', 0.03);
hold on
plot(distances, SHD_dist);
hold on
histogram(DH_distances, 'BinWidth', 0.03);
hold on
plot(distances, DHD_dist);
hold on
xline(d_c, '--'); 
title('Similar HDs compared to Different HDs');
legend('Similar HDs', 'Normal distribution for similar HDs', 'Different HDs', 'Normal distribution for different HDs', 'Decision criterion');
xlabel('Distance');
ylabel('Frequency');


