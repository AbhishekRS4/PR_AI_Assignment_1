% determine the decision criterion
% for our approach, we decided to start with a decision criterion of 0.25
% this value was selected based on the histogram

initail_dc = 0.25;
while initail_dc > 0
    % we denoted false acceptance rate by alpha
    alpha = normcdf(initail_dc, DHD_mean, sqrt(DHD_var));
    if alpha <= 0.0005
        final_dc = initail_dc;
        break
    end
    % if we couldn't find an alpha smaller than 0.0005, we subtract 0.0001
    % from the current value of the decision criterion, since the current 
    % value is too high
    initail_dc = initail_dc - 0.0001;
end

fprintf('decision criterion:');
disp(final_dc);

% determine the false rejection rate
% we denoted false rejection rate by beta
beta = 1 - normcdf(final_dc, SHD_mean, sqrt(SHD_var));
fprintf('false rejection rate:');
disp(beta);