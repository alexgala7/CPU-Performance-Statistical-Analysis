function [param_cov, boot_cov] = Group7Exe4Fun1(dataVector, M, n, alpha)
% Group7Exe4Fun1 Calculates CI coverage for Parametric and Bootstrap methods.
%
% INPUTS:
%   dataVector: The full column of data (population)
%   M:          Number of iterations (e.g., 100)
%   n:          Sample size (e.g., 20)
%   alpha:      Significance level (e.g., 0.05 for 95% CI)
%
% OUTPUTS:
%   param_cov:  Percentage of Parametric CIs containing the true mean
%   boot_cov:   Percentage of Bootstrap CIs containing the true mean
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % Calculate the true population mean
    true_mean = mean(dataVector);
    total_N = length(dataVector);
    
    param_count = 0;
    boot_count = 0;
    
    % t-critical value for parametric CI (two-tailed)
    t_crit = tinv(1 - alpha/2, n - 1);
    
    for i = 1:M
        % 1. Select random sample of size n
        random_indices = randperm(total_N, n);
        sample_data = dataVector(random_indices);
        
        % 2. Parametric Confidence Interval
        sample_mean = mean(sample_data);
        sample_std = std(sample_data);
        margin_of_error = t_crit * (sample_std / sqrt(n));
        ci_param = [sample_mean - margin_of_error, sample_mean + margin_of_error];
        
        % Check if true mean is inside Parametric CI
        if true_mean >= ci_param(1) && true_mean <= ci_param(2)
            param_count = param_count + 1;
        end
        
        % 3. Bootstrap Confidence Interval
        % We use 1000 bootstrap samples, and the 'percentile' method
        ci_boot = bootci(1000, {@mean, sample_data}, 'Type', 'per', 'Alpha', alpha);
        
        % Check if true mean is inside Bootstrap CI
        if true_mean >= ci_boot(1) && true_mean <= ci_boot(2)
            boot_count = boot_count + 1;
        end
    end
    
    % Calculate percentages
    param_cov = (param_count / M) * 100;
    boot_cov = (boot_count / M) * 100;

end
