% Group7Exe7Prog1.m
% Program to test the null hypothesis of zero correlation (rho = 0) 
% between MMAX and CHMIN using Parametric and Randomization tests.
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
alpha = 0.05;

fprintf('--------------------------------------------------------------------\n');
fprintf(' EXERCISE 7: HYPOTHESIS TESTING FOR ZERO CORRELATION (H0: rho = 0)\n');
fprintf(' Comparing MMAX and CHMIN (M=%d iterations, n=%d sample size)\n', M_iterations, n_sample);
fprintf('--------------------------------------------------------------------\n');

% --- 2. Process RAW Data ---
[param_raw, rand_raw] = Group7Exe7Fun1(MMAX_raw, CHMIN_raw, M_iterations, n_sample, alpha);

% --- 3. Process LOG Transformed Data ---
MMAX_log = log(MMAX_raw + eps);
CHMIN_log = log(CHMIN_raw + eps);

[param_log, rand_log] = Group7Exe7Fun1(MMAX_log, CHMIN_log, M_iterations, n_sample, alpha);

% --- 4. Print Results ---
fprintf('%-25s | %-15s | %-15s \n', 'Data Type', 'Parametric Rej%', 'Randomization Rej%');
fprintf('--------------------------------------------------------------------\n');
fprintf('%-25s |     %6.1f%%    |     %6.1f%% \n', 'RAW DATA', param_raw, rand_raw);
fprintf('%-25s |     %6.1f%%    |     %6.1f%% \n', 'LOG TRANSFORMED DATA', param_log, rand_log);
fprintf('--------------------------------------------------------------------\n\n');

% --- 5. Comments and Conclusions ---
%
% COMMENTS ON RESULTS (Based on Output):
%
% 1. Interpretation of Rejection Rate (Statistical Power):
%    - In reality, MMAX (Max Memory) and CHMIN (Min Channels) are positively 
%      correlated. Therefore, the Null Hypothesis (H0: rho = 0) is FALSE.
%    - The high rejection rates in the Raw Data (~84% and ~78%) represent the 
%      "Statistical Power" of our tests: their ability to correctly detect the 
%      true underlying correlation even in a small sample of n=20.
%
% 2. Parametric vs. Randomization Tests:
%    - The rejection rates for both the Parametric (~84%) and Randomization (~78%) 
%      tests are very similar. 
%    - Even though the Parametric test assumes Bivariate Normality (which Raw 
%      Data heavily violates), the t-test for correlation is surprisingly robust. 
%    - The Randomization test, being non-parametric, reaches highly consistent 
%      decisions without relying on distributional assumptions.
%
% 3. Raw vs. Log-Transformed Data (The Destructive Effect of Outliers):
%    - We observe a massive drop in rejection rates (down to ~28% and ~31%) 
%      when using Log-Transformed data.
%    - Reason: As noted in previous exercises, calculating log(CHMIN + eps) creates 
%      massive artificial negative outliers (approx -36) for values that were 
%      originally zero. In a small sample of n=20, these outliers completely wash 
%      out the true positive trend between the variables. Since the correlation 
%      is destroyed by the log(0) workaround, both tests fail to reject H0, causing 
%      the statistical power to drop drastically.
%
% CONCLUSION:
% For testing correlation, parametric and randomization methods yield highly 
% consistent results. However, inappropriate data transformations (like taking 
% the logarithm of zero-inflated, discrete variables like CHMIN) can completely 
% destroy the underlying relationship and cripple the statistical power of any test.
