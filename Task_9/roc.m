function roc(discrimi_trial_and_error)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the default value of discrminability to be 
    % used for by trial and error
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eval('discrimi_trial_and_error;', 'discrimi_trial_and_error = 2.165;');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load the given dataset
    % compute FPR and TPR for the given dataset
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y_outcomes_struct = load("task_9_outcomes.mat");
    y_outcomes = y_outcomes_struct.outcomes;
    
    y_signal_shown = y_outcomes(:, 1);
    y_signal_detected = y_outcomes(:, 2);
    
    TPR_dataset = sum((y_signal_shown == 1) & (y_signal_detected == 1)) / sum(y_signal_shown == 1);
    FPR_dataset = sum((y_signal_shown == 0) & (y_signal_detected == 1)) / sum(y_signal_shown == 0);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute points on ROC curve
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num_values = 20;
    mu_1 = 5;
    variance = 4;
    std_dev = sqrt(variance);
    
    mu2_trial_and_error = compute_mean_2(mu_1, discrimi_trial_and_error, std_dev);
    mu_2_list = [7, 9, 11, mu2_trial_and_error];
    colors_list = ["r", "g", "b", "k"];
    
    size_pdfs = size(mu_2_list);
    num_pdfs = size_pdfs(2);
    
    TPR_list = zeros(num_pdfs, num_values);
    FPR_list = zeros(num_pdfs, num_values);
    discrimi_list = zeros(1, num_pdfs);
    
    for index_pdfs=1:num_pdfs
        mu_2 = mu_2_list(index_pdfs);
        discrimi = compute_discriminability(mu_1, mu_2, std_dev);
        discrimi_list(index_pdfs) = discrimi;
        
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
        
        for index_values=1:num_values
            if bad_pdf(index_values) > 0
                cum_FPR = cum_FPR + good_pdf(num_values - index_values + 1);
                cum_TPR = cum_TPR + bad_pdf(num_values - index_values + 1);
            end
            FPR = cum_FPR / total_good;
            TPR = cum_TPR / total_bad;
            
            FPR_list(index_pdfs, index_values) = FPR;
            TPR_list(index_pdfs, index_values) = TPR;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot 3 ROC curves for 3 scenarios
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(1);
    hold on;
    for index_pdfs=1:num_pdfs-1
        mu_2 = mu_2_list(index_pdfs);
        discrimi = discrimi_list(index_pdfs);
        legend_str = "\mu_1="+mu_1+" \mu_2="+mu_2+", \sigma="+std_dev+", discriminability="+discrimi;
        plot_figure(FPR_list(index_pdfs, :), TPR_list(index_pdfs, :), colors_list(index_pdfs), legend_str)
    end
    legend("Location", "Best");
    title("ROC Curve for 3 scenarios");
    xlabel("FPR");
    ylabel("TPR");
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot all ROC curves including the ROC curve
    % found by trial and error
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(2);
    hold on;
    for index_pdfs=1:num_pdfs
        discrimi = discrimi_list(index_pdfs);
        legend_str = "discriminability="+discrimi;
        plot_figure(FPR_list(index_pdfs, :), TPR_list(index_pdfs, :), colors_list(index_pdfs), legend_str)
    end
    legend_str = "FPR="+FPR_dataset+", TPR="+TPR_dataset;
    plot(FPR_dataset, TPR_dataset, "k+", "DisplayName", legend_str);
    legend("Location", "Best");
    title("ROC Curve to determine discriminability by trial and error");
    xlabel("FPR");
    ylabel("TPR");
end

% plot x and y arrays along with legend name
function plot_figure(FPR, TPR, color, legend_str)
    plot(FPR, TPR, color, "DisplayName", legend_str);
end

% compute discriminability given other parameters
function discrimi=compute_discriminability(mu_1, mu_2, std_dev)
    discrimi=abs(mu_1 - mu_2) / std_dev;
end

% compute mu_2 given other required parameters
function mu_2=compute_mean_2(mu_1, discrimi, std_dev)
    mu_2 = mu_1 + (std_dev * discrimi);
end