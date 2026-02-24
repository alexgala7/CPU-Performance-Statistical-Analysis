% Group7Exe5Prog1.m
% Program to randomly compare 10 pairs of CPU vendors based on PRP.
% Evaluates Normality, plots Boxplots, and tests for significant difference.
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

clc;
clear;
close all;

% --- 1. Load Data ---
filename = 'CPUperformance.xlsx'; 
if isfile(filename)
    full_data = xlsread(filename);
else
    error('File CPUperformance.xls not found.');
end

vendor_codes = full_data(:, 1);
prp = full_data(:, 9);

% Allowed vendors based on prompt (Codes 1 to 12)
valid_vendors = 1:12;

iterations = 10;
alpha = 0.05;

% Counters for final report
count_normality_rejected = 0;
count_significant_diff = 0;

% Setup figure for Boxplots
figure('Name', 'Boxplots for 10 Random Vendor Pairs', 'Position', [100, 100, 1200, 600]);

fprintf('----------------------------------------------------------------------\n');
fprintf(' EXERCISE 5: COMPARING 10 RANDOM VENDOR PAIRS (PRP)\n');
fprintf('----------------------------------------------------------------------\n');

for i = 1:iterations
    % --- 2. Randomly select two UNIQUE vendors ---
    v_pair = randsample(valid_vendors, 2);
    v1 = v_pair(1);
    v2 = v_pair(2);
    
    % Extract PRP data for these vendors
    data1 = prp(vendor_codes == v1);
    data2 = prp(vendor_codes == v2);
    
    % --- 3. Plot Boxplots ---
    subplot(2, 5, i);
    % We use a grouping variable to plot arrays of different lengths easily
    grouping = [ones(length(data1), 1); 2 * ones(length(data2), 1)];
    combined_data = [data1; data2];
    boxplot(combined_data, grouping, 'Labels', {['V' num2str(v1)], ['V' num2str(v2)]});
    title(['Pair ' num2str(i)]);
    ylabel('PRP');
    
    % --- 4. Call Evaluation Function ---
    [norm_rej, sig_diff, ci, method] = Group7Exe5Fun1(data1, data2, alpha);
    
    % Update counters
    if norm_rej
        count_normality_rejected = count_normality_rejected + 1;
    end
    if sig_diff
        count_significant_diff = count_significant_diff + 1;
    end
    
    % Print per-iteration log
    fprintf('Pair %2d (V%02d vs V%02d) | Method: %-20s | Sig. Diff: %d\n', ...
        i, v1, v2, method, sig_diff);
end

% --- 5. Print Final Results ---
fprintf('----------------------------------------------------------------------\n');
fprintf('RESULTS SUMMARY:\n');
fprintf('Total times Normality was REJECTED: %d / %d\n', count_normality_rejected, iterations);
fprintf('Total times Significant Difference found: %d / %d\n', count_significant_diff, iterations);
fprintf('----------------------------------------------------------------------\n');

% --- 6. Comments and Conclusions ---
%
% COMMENTS ON RESULTS (Based on Output & Boxplots):
%
% 1. Rejection of Normality (Visual Confirmation):
%    - In almost all iterations, the null hypothesis of Normality is rejected.
%    - The generated boxplots provide clear visual proof of why: almost all vendor 
%      distributions exhibit severe right-skewness and contain numerous extreme 
%      outliers (indicated by the orange '+' marks). 
%    - Due to this extreme non-normality, the algorithm correctly falls back to 
%      the robust Bootstrap method in the vast majority of cases.
%
% 2. Statistical Difference between Vendors:
%    - The presence of a statistically significant difference varies depending on 
%      the random pair selected, which is completely expected.
%    - Visual Alignment: In pairs where the boxes overlap heavily (e.g., similar 
%      medians and IQR), the Bootstrap CI successfully identifies that there is NO 
%      significant difference. 
%    - Conversely, when a high-end vendor is paired with a lower-end one (visible 
%      as one box being distinctly higher than the other), the CI does not contain 
%      zero, confirming a significant difference in average performance.
%
% CONCLUSION:
% The visual evidence from the boxplots perfectly aligns with the statistical tests.
% Assuming Normality for CPU performance across vendors is fundamentally incorrect. 
% Non-parametric or resampling methods (like Bootstrap) are absolutely essential 
% for safely and robustly comparing hardware performance metrics.
