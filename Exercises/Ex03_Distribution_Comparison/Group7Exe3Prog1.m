% Group7Exe3Prog1.m
% Program to test if random samples follow the population distribution.
% Uses Kolmogorov-Smirnov test (kstest2).
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
    error('File not found.');
end

% Indices for attributes: 
% 3: MYCT
% 5: MMAX 
% 7: CHMIN
columns_to_analyze = [3, 5, 7];
col_names = {'MYCT', 'MMAX', 'CHMIN'};

% Parameters
n_sample = 40;        % Sample size (keeping consistency with Ex.2)
M_iterations = 100;   % Number of iterations
alpha = 0.05;         % Significance level

fprintf('------------------------------------------------------------\n');
fprintf('Results of K-S Test (Sample vs Population)\n');
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
        p_val = Group7Exe3Fun1(current_data, n_sample);
        % If p >= alpha, we Accept H0 (Sample comes from Population)
        if p_val >= alpha
            pass_count_raw = pass_count_raw + 1;
        end
    end
    percentage_raw = (pass_count_raw / M_iterations) * 100;
    
    % --- CASE B: LOG TRANSFORMED DATA ---
    log_data = log(current_data + eps); 
    
    pass_count_log = 0;
    for k = 1:M_iterations
        p_val = Group7Exe3Fun1(log_data, n_sample);
        if p_val >= alpha
            pass_count_log = pass_count_log + 1;
        end
    end
    percentage_log = (pass_count_log / M_iterations) * 100;
    
    % Print Result
    fprintf('%-10s | %13.1f%%  | %13.1f%% \n', col_names{i}, percentage_raw, percentage_log);
end
fprintf('------------------------------------------------------------\n');

% --- 3. Comments and Conclusions ---
%
% COMMENTS ON RESULTS (Based on simulation output):
%
% 1. High Acceptance Rates (~98-100%):
%    - The Null Hypothesis (that the sample comes from the population) is 
%      accepted in almost all cases.
%    - This confirms that a random sample of n=40 is statistically representative 
%      of the total population (N=209). The empirical CDF of the sample matches 
%      the empirical CDF of the population.
%
% 2. Raw vs Log Transformation:
%    - The pass rates are extremely similar for both Raw and Log data (e.g., 
%      98% vs 99%).
%    - Theoretically, the Kolmogorov-Smirnov test is invariant to monotonic 
%      transformations like the logarithm. It depends on the relative rank of 
%      values, not their scale.
%    - Small differences in our results (e.g., 1-2%) are due to the fact that 
%      the simulation generates fresh random samples for the second loop.
%
% 3. Comparison with Exercise 2:
%    - In Exercise 2, we rejected Normality for attributes like CHMIN (0% pass).
%    - In Exercise 3, we accept that the sample matches the Population (100% pass).
%    - Conclusion: Even if the population is NOT Normal (like CHMIN), the 
%      sample is still a perfect representative of that non-normal population.
%
% GENERAL CONCLUSION:
% The sampling method preserves the statistical properties of the population 
% for all attributes, regardless of their distribution shape (Normal or skewed).
