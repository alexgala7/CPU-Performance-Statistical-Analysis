function [param_rej_rate, rand_rej_rate] = Group7Exe7Fun1(data1, data2, M, n, alpha)
% Group7Exe7Fun1 Performs Parametric and Randomization tests for zero correlation.
%
% INPUTS:
%   data1, data2: The two full data columns (e.g., MMAX and CHMIN)
%   M:            Number of iterations (e.g., 100)
%   n:            Sample size (e.g., 20)
%   alpha:        Significance level (e.g., 0.05)
%
% OUTPUTS:
%   param_rej_rate: Percentage of times H0 (rho=0) is rejected (Parametric)
%   rand_rej_rate:  Percentage of times H0 (rho=0) is rejected (Randomization)
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    total_N = length(data1);
    
    count_param_reject = 0;
    count_rand_reject = 0;
    
    % Critical t-value for two-tailed parametric test
    t_crit = tinv(1 - alpha/2, n - 2);
    
    B_permutations = 1000; % Number of shuffles for randomization test
    
    for i = 1:M
        % 1. Select random sample of size n (SAME indices for both variables)
        random_indices = randperm(total_N, n);
        x = data1(random_indices);
        y = data2(random_indices);
        
        % Calculate sample correlation (r)
        R_matrix = corrcoef(x, y);
        r = R_matrix(1, 2);
        
        % Handle edge cases (NaN or perfect correlation)
        if isnan(r) || abs(r) == 1
            continue; 
        end
        
        % --- 2. PARAMETRIC TEST ---
        % Calculate t-statistic: t = r * sqrt(n-2) / sqrt(1-r^2)
        t_stat = r * sqrt(n - 2) / sqrt(1 - r^2);
        
        % Reject H0 if absolute t-statistic is greater than critical value
        if abs(t_stat) > t_crit
            count_param_reject = count_param_reject + 1;
        end
        
        % --- 3. RANDOMIZATION (PERMUTATION) TEST ---
        count_extreme = 0;
        
        for b = 1:B_permutations
            % Shuffle the y-values randomly, breaking any true relationship with x
            y_shuffled = y(randperm(n));
            
            % Calculate correlation of shuffled data
            R_perm = corrcoef(x, y_shuffled);
            r_perm = R_perm(1, 2);
            
            % Check if shuffled correlation is as extreme as the original
            if abs(r_perm) >= abs(r)
                count_extreme = count_extreme + 1;
            end
        end
        
        % The p-value is the proportion of shuffles that produced an equal or stronger correlation
        p_rand = count_extreme / B_permutations;
        
        % Reject H0 if p-value is less than or equal to alpha
        if p_rand <= alpha
            count_rand_reject = count_rand_reject + 1;
        end
    end
    
    % Calculate rejection rates (%)
    param_rej_rate = (count_param_reject / M) * 100;
    rand_rej_rate = (count_rand_reject / M) * 100;

end
