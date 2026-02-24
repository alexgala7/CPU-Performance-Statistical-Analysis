% Group7Exe2Prog1.m
% Program to test Normality (Chi-Square) on raw and log-transformed data.
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

% Indices for attributes: 
% 3: MYCT (machine cycle time)
% 5: MMAX (maximum main memory) -- Requested by Exercise 2
% 7: CHMIN (minimum channels)
columns_to_analyze = [3, 5, 7];
col_names = {'MYCT', 'MMAX', 'CHMIN'};

% Parameters
n_sample = 40;        % Sample size
M_iterations = 100;   % Number of iterations
alpha = 0.05;         % Significance level

fprintf('------------------------------------------------------------\n');
fprintf('Results of Chi-Square Goodness-of-Fit Test (Normal Dist.)\n');
fprintf('Iterations: %d | Sample Size: %d | Alpha: %.2f\n', M_iterations, n_sample, alpha);
fprintf('------------------------------------------------------------\n');
fprintf('%-10s | %-15s | %-15s\n', 'Attribute', 'Raw Data Pass %', 'Log Data Pass %');
fprintf('------------------------------------------------------------\n');

% --- 2. Process each attribute ---
for i = 1:length(columns_to_analyze)
    col_idx = columns_to_analyze(i);
    current_data = full_data(:, col_idx);
    
    % --- CASE A: RAW DATA ---
    pass_count_raw = 0;
    for k = 1:M_iterations
        p_val = Group7Exe2Fun1(current_data, n_sample);
        % If p_val >= alpha, we DO NOT Reject H0 (So, it IS Normal)
        if p_val >= alpha
            pass_count_raw = pass_count_raw + 1;
        end
    end
    percentage_raw = (pass_count_raw / M_iterations) * 100;
    
    % --- CASE B: LOG TRANSFORMED DATA ---
    % Apply natural logarithm y = log(x)
    % Note: Adding eps to avoid log(0) if any data is exactly 0.
    log_data = log(current_data + eps); 
    
    pass_count_log = 0;
    for k = 1:M_iterations
        p_val = Group7Exe2Fun1(log_data, n_sample);
        if p_val >= alpha
            pass_count_log = pass_count_log + 1;
        end
    end
    percentage_log = (pass_count_log / M_iterations) * 100;
    
    % Print Result for this attribute
    fprintf('%-10s | %13.1f%%  | %13.1f%% \n', col_names{i}, percentage_raw, percentage_log);
end
fprintf('------------------------------------------------------------\n');

% --- 3. Comments and Conclusions ---
%
% COMMENTS ON RESULTS (Based on simulation output):
%
% 1. MYCT (Machine Cycle Time):
%    - Raw Data: The Null Hypothesis (Normality) is rejected in most cases (~10% pass rate).
%    - Log Data: The pass rate jumps significantly to ~78%.
%    - Conclusion: The Logarithm successfully transforms the skewed data into a 
%      Normal distribution. MYCT follows a Log-Normal distribution.
%
% 2. MMAX (Maximum Main Memory):
%    - Raw Data: Very low pass rate (~13%).
%    - Log Data: Improves to ~31%, but still rejected in the majority of cases.
%    - Reason: Memory sizes are discrete values (powers of 2). Even after 
%      logging, the data remains "clumpy" (multimodal/discrete) rather than 
%      smoothly continuous, causing the Chi-Square test to fail often.
%
% 3. CHMIN (Minimum Channels):
%    - Raw Data: Extremely low pass rate (~4%).
%    - Log Data: Stays very low (~5%). No improvement.
%    - Reason: This attribute is highly discrete with small integer values 
%      (often 0, 1, 2). A log transformation cannot turn such sparse, discrete 
%      integers into a smooth Bell Curve. It is inherently non-normal.
%
% GENERAL CONCLUSION:
% The Log transformation is highly effective for continuous, right-skewed time 
% variables like MYCT, changing the decision from "Reject" to "Accept" Normality. 
% However, for discrete hardware attributes like Channels (CHMIN) or Memory (MMAX), 
% the transformation is less effective because the underlying discreteness 
% violates the continuity assumption of the Normal distribution.
