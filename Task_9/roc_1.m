function roc_1()
    num_values = 20;
    mu_1 = 5;
    mu_2_list = [7, 9, 11];
    colors_list = ["r", "g", "b"];
    variance = 4;
    std_dev = sqrt(variance);
    size_pdfs = size(mu_2_list);
    num_pdfs = size_pdfs(2);
    
    figure(1);
    hold on;
    
    for index_pdfs=1:num_pdfs
        mu_2 = mu_2_list(index_pdfs);
        discrimi = compute_discriminability(mu_1, mu_2, std_dev);
        
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
        legend_str = "\mu_1=5, \mu_2="+mu_2+", \sigma="+std_dev+", discriminability="+discrimi;
        plot(FPR_list, TPR_list, colors_list(index_pdfs), "DisplayName", legend_str);
    end
    legend("Location", "Best");
    title("ROC Curve");
    xlabel("FPR");
    ylabel("TPR")
end

function discrimi=compute_discriminability(mu_1, mu_2, std_dev)
    discrimi=abs(mu_1 - mu_2) / std_dev;
end