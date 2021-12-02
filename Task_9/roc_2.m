function roc_2(discrimi)
    eval('discrimi;', 'discrimi = 2.165;');
    y_outcomes_struct = load("task_9_outcomes.mat");
    y_outcomes = y_outcomes_struct.outcomes;
    
    y_signal_shown = y_outcomes(:, 1);
    y_signal_detected = y_outcomes(:, 2);
    
    TPR_rate = sum((y_signal_shown == 1) & (y_signal_detected == 1)) / sum(y_signal_shown == 1);
    FPR_rate = sum((y_signal_shown == 0) & (y_signal_detected == 1)) / sum(y_signal_shown == 0);
    
    % find the value of discriminability by trial and error
    roc_1(FPR_rate, TPR_rate, discrimi);
end

function roc_1(FPR_rate, TPR_rate, discrimi)
    num_values = 20;
    mu_1 = 5;
    variance = 4;
    std_dev = sqrt(variance);
    
    % we do not know the exact value of mu_2
    mu_2 = compute_mean_2(mu_1, discrimi, std_dev);
    
    figure(2);
    hold on;

    x = linspace((mu_1 - (3 * std_dev)), (mu_2 + (3 * std_dev)), num_values);
    %fprintf("%.3f %.3f\n", min(x), max(x));
    good_pdf = normpdf(x, mu_1, std_dev);
    %fprintf("%.3f %.3f\n", min(good_pdf), max(good_pdf));
    bad_pdf = normpdf(x, mu_2, std_dev);
    %fprintf("%.3f %.3f\n", min(bad_pdf), max(bad_pdf));

    total_good = sum(good_pdf);
    total_bad = sum(bad_pdf);

    cum_TPR = 0;
    cum_FPR = 0;

    TPR_list = zeros(1, num_values);
    FPR_list = zeros(1, num_values);

    for index_values=1:num_values
        if bad_pdf(index_values) > 0
            cum_FPR = cum_FPR + good_pdf(num_values - index_values + 1);
            cum_TPR = cum_TPR + bad_pdf(num_values - index_values + 1);
        end
        FPR = cum_FPR / total_good;
        TPR = cum_TPR / total_bad;

        FPR_list(index_values) = FPR;
        TPR_list(index_values) = TPR;
    end
    legend_str = "discriminability="+discrimi;
    plot(FPR_list, TPR_list, "DisplayName", legend_str);
    
    legend_str = "FPR="+FPR_rate+", TPR="+TPR_rate;
    plot(FPR_rate, TPR_rate, "bx", "DisplayName", legend_str);
    legend("Location", "Best");
    title("ROC Curve");
    xlabel("FPR");
    ylabel("TPR")
end

function mu_2=compute_mean_2(mu_1, discrimi, std_dev)
    mu_2 = mu_1 + (std_dev * discrimi);
end