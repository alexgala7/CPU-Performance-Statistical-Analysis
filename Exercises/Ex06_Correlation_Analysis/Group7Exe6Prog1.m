% Group7Exe6Prog1.m
% Program to evaluate 95% Confidence Intervals for Correlation (Fisher Method)
% between MMAX and CHMIN, on Raw and Log-transformed data.
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

% Extract specific attributes: MMAX (Col 5) and CHMIN (Col 7)
MMAX_raw = full_data(:, 5);
CHMIN_raw = full_data(:, 7);

% Parameters
M_iterations = 100;
n_sample = 20;
alpha = 0.05; % For 95% CI

fprintf('--------------------------------------------------------------------\n');
fprintf(' EXERCISE 6: 95%% CI COVERAGE FOR CORRELATION (Fisher Transform)\n');
fprintf(' Comparing MMAX and CHMIN (M=%d iterations, n=%d sample size)\n', M_iterations, n_sample);
fprintf('--------------------------------------------------------------------\n');

% --- 2. Process RAW Data ---
coverage_raw = Group7Exe6Fun1(MMAX_raw, CHMIN_raw, M_iterations, n_sample, alpha);

% --- 3. Process LOG Transformed Data ---
% Add 'eps' to avoid log(0) for CHMIN which contains many zeros
MMAX_log = log(MMAX_raw + eps);
CHMIN_log = log(CHMIN_raw + eps);

coverage_log = Group7Exe6Fun1(MMAX_log, CHMIN_log, M_iterations, n_sample, alpha);

% --- 4. Print Results ---
fprintf('%-25s | %-15s \n', 'Data Type', 'CI Coverage %');
fprintf('--------------------------------------------------------------------\n');
fprintf('%-25s |     %6.1f%% \n', 'RAW DATA', coverage_raw);
fprintf('%-25s |     %6.1f%% \n', 'LOG TRANSFORMED DATA', coverage_log);
fprintf('--------------------------------------------------------------------\n\n');

% --- 5. Comments and Conclusions ---
%
% COMMENTS ON RESULTS:
%
% 1. Raw Data Behavior:
%    - The coverage for the raw data (~83%) is significantly lower than the 
%      expected nominal level of 95%.
%    - Reason: Fisher's Z-transformation mathematically assumes that the two 
%      variables follow a Bivariate Normal distribution. Both MMAX and CHMIN 
%      are heavily right-skewed and discrete. This fundamental violation of the 
%      Normality assumption leads to inaccurate Confidence Intervals that fail 
%      to capture the true population correlation frequently.
%
% 2. Log-Transformed Data Behavior (The CHMIN Anomaly):
%    - The Log transformation only slightly improves coverage (to ~87%), which 
%      is still unacceptably far from the 95% target.
%    - Reason: While log(MMAX) makes the MMAX variable somewhat symmetric, CHMIN 
%      contains numerous exact zero values. Calculating log(0+eps) creates massive 
%      negative artificial outliers (approx -36). When selecting a small sample 
%      of n=20, these outliers completely destabilize the sample correlation 
%      coefficient (r), rendering the Fisher transformation unreliable.
%
% CONCLUSION:
% Parametric correlation estimates and Fisher-based Confidence Intervals are highly 
% sensitive to departures from Bivariate Normality. For skewed, zero-inflated 
% variables like CHMIN, neither the raw form nor the log-transformed form provides 
% statistically valid 95% confidence intervals at such a small sample size (n=20).
