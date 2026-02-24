function coverage = Group7Exe6Fun1(data1, data2, M, n, alpha)
% Group7Exe6Fun1 Calculates CI coverage for Correlation using Fisher Transform.
%
% INPUTS:
%   data1, data2: The two full data columns to correlate (e.g., MMAX and CHMIN)
%   M:            Number of iterations (e.g., 100)
%   n:            Sample size (e.g., 20)
%   alpha:        Significance level (e.g., 0.05 for 95% CI)
%
% OUTPUTS:
%   coverage:     Percentage of 95% CIs containing the true population correlation
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % 1. Calculate the TRUE population correlation coefficient (rho)
    % corrcoef returns a 2x2 matrix, off-diagonal is the correlation
    true_R_matrix = corrcoef(data1, data2);
    true_rho = true_R_matrix(1, 2);
    
    total_N = length(data1);
    
    % Critical Z-value for Normal distribution (since Fisher transform is approx Normal)
    z_crit = norminv(1 - alpha/2); 
    
    % Standard error for Fisher's Z is 1 / sqrt(n - 3)
    se_z = 1 / sqrt(n - 3);
    
    count_success = 0;
    
    for i = 1:M
        % 2. Select random sample of size n
        % We MUST select the SAME indices for both variables to keep pairs intact!
        random_indices = randperm(total_N, n);
        sample1 = data1(random_indices);
        sample2 = data2(random_indices);
        
        % 3. Calculate sample correlation (r)
        sample_R_matrix = corrcoef(sample1, sample2);
        r = sample_R_matrix(1, 2);
        
        % Handle edge cases (e.g., if standard deviation is 0 in a small sample, r is NaN)
        % or if r is exactly 1 or -1 (Fisher transform would go to infinity).
        if isnan(r) || abs(r) >= 1
            continue; % Skip this iteration, it's a failed CI
        end
        
        % 4. Fisher's Z-Transformation
        z = 0.5 * log((1 + r) / (1 - r));  % equivalent to atanh(r)
        
        % 5. Confidence Interval in Z-space
        z_lower = z - z_crit * se_z;
        z_upper = z + z_crit * se_z;
        
        % 6. Transform back to correlation space (r)
        % Inverse Fisher is tanh(z) = (exp(2z)-1)/(exp(2z)+1)
        ci_lower = tanh(z_lower);
        ci_upper = tanh(z_upper);
        
        % 7. Check if true rho is inside the CI
        if true_rho >= ci_lower && true_rho <= ci_upper
            count_success = count_success + 1;
        end
    end
    
    % Calculate coverage percentage
    coverage = (count_success / M) * 100;

end
