function [normality_rejected, sig_diff, ci, method] = Group7Exe5Fun1(data1, data2, alpha)
% Group7Exe5Fun1 Evaluates difference in means between two samples.
% Uses Parametric t-test if both are Normal, otherwise uses Bootstrap.
%
% INPUTS:
%   data1, data2: The two samples (PRP values) to compare
%   alpha:        Significance level (e.g., 0.05)
%
% OUTPUTS:
%   normality_rejected: Boolean (true if H0 for normality is rejected for either sample)
%   sig_diff:           Boolean (true if the 95% CI does not contain 0)
%   ci:                 The 95% Confidence Interval [lower, upper]
%   method:             String name of the method used
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % 1. Check Normality using Chi-Square goodness-of-fit test
    % We suppress low counts warnings since some vendors have small sample sizes
    warning('off', 'stats:chi2gof:LowCounts');
    [~, p1] = chi2gof(data1);
    [~, p2] = chi2gof(data2);
    warning('on', 'stats:chi2gof:LowCounts');

    % 2. Decide Method based on p-values
    if p1 >= alpha && p2 >= alpha
        % Both are Normal -> Use Parametric Student's t-test
        normality_rejected = false;
        method = 'Parametric (Student)';
        
        % ttest2 calculates the 95% CI for the difference of means
        [~, ~, ci] = ttest2(data1, data2, 'Alpha', alpha);
        
    else
        % At least one is not Normal -> Use Bootstrap
        normality_rejected = true;
        method = 'Bootstrap';
        
        n_boot = 1000;
        
        % Generate bootstrap means for both samples independently
        boot_means1 = bootstrp(n_boot, @mean, data1);
        boot_means2 = bootstrp(n_boot, @mean, data2);
        
        % Calculate the difference of means
        boot_diffs = boot_means1 - boot_means2;
        
        % 95% CI is the 2.5th and 97.5th percentiles of the differences
        ci = prctile(boot_diffs, [100*alpha/2, 100*(1-alpha/2)]);
    end

    % 3. Check for Statistical Significance
    % If 0 is NOT inside the CI, the difference is statistically significant
    if ci(1) > 0 || ci(2) < 0
        sig_diff = true;
    else
        sig_diff = false;
    end

end
