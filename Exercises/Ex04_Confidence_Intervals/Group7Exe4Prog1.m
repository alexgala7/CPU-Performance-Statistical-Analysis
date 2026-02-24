% Group7Exe4Prog1.m
% Program to evaluate 95% Confidence Intervals (Parametric vs Bootstrap)
% on Raw and Log-transformed data.
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

% Indices for attributes: 3 (MYCT), 5 (MMAX), 7 (CHMIN)
columns_to_analyze = [3, 5, 7];
col_names = {'MYCT', 'MMAX', 'CHMIN'};

% Parameters
M_iterations = 100; % Number of CIs to construct
n_sample = 20;      % Sample size
alpha = 0.05;       % For 95% CI

fprintf('--------------------------------------------------------------------\n');
fprintf(' 95%% CONFIDENCE INTERVAL COVERAGE (M=%d, n=%d)\n', M_iterations, n_sample);
fprintf('--------------------------------------------------------------------\n');
fprintf('%-10s | %-25s | %-25s\n', 'Attribute', 'RAW DATA: Param% / Boot%', 'LOG DATA: Param% / Boot%');
fprintf('--------------------------------------------------------------------\n');

for i = 1:length(columns_to_analyze)
    col_idx = columns_to_analyze(i);
    current_data = full_data(:, col_idx);
    
    % --- CASE A: RAW DATA ---
    [param_raw, boot_raw] = Group7Exe4Fun1(current_data, M_iterations, n_sample, alpha);
    
    % --- CASE B: LOG TRANSFORMED DATA ---
    % Add a very small number (eps) to prevent log(0) if any values are 0
    log_data = log(current_data + eps); 
    [param_log, boot_log] = Group7Exe4Fun1(log_data, M_iterations, n_sample, alpha);
    
    % Print Results
    fprintf('%-10s |      %6.1f%% / %6.1f%%    |      %6.1f%% / %6.1f%% \n', ...
        col_names{i}, param_raw, boot_raw, param_log, boot_log);
end
fprintf('--------------------------------------------------------------------\n');


% --- 3. Comments and Conclusions ---
%
% COMMENTS ON RESULTS (Based on Simulation):
%
% 1. Raw Data Performance (Under-coverage):
%    - For all attributes (MYCT, MMAX, CHMIN), the coverage of the 95% Confidence 
%      Intervals on raw data is around 88-90%, which is strictly less than the 
%      nominal 95%.
%    - Reason: The data is heavily right-skewed. With a very small sample size 
%      (n=20), the Central Limit Theorem is not sufficient to normalize the sample 
%      mean distribution. Both Parametric and Bootstrap CIs struggle to capture 
%      the true population mean reliably in such skewed conditions.
%
% 2. Log-Transformed Data Performance (MYCT & MMAX):
%    - For MYCT and MMAX, the log transformation significantly improves coverage, 
%      bringing it up to the expected ~94-96%.
%    - Reason: The logarithm successfully normalizes the continuous, right-skewed 
%      data. Once symmetric, the assumptions of the Student-t distribution are met, 
%      and the Bootstrap method perfectly captures the underlying shape.
%
% 3. The CHMIN Anomaly (Catastrophic Failure):
%    - For CHMIN, the log transformation causes the coverage to drop drastically 
%      to ~46-48%.
%    - Reason: CHMIN is highly discrete and contains many absolute zero (0) values. 
%      To avoid log(0), we add a tiny 'eps'. However, log(eps) results in a massive 
%      negative outlier (approx -36). In a small sample of n=20, catching even one 
%      of these artificial outliers completely distorts the sample mean and variance, 
%      causing the Confidence Interval to fail completely. 
%
% GENERAL CONCLUSION:
% For skewed continuous variables, the log transformation is highly recommended 
% when estimating means with small samples. However, applying a logarithmic 
% transformation to discrete, zero-heavy data (like CHMIN) is mathematically and 
% statistically dangerous, leading to severely invalid Confidence Intervals.
