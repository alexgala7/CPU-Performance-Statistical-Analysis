% Group7Exe9Prog1.m
% Program to compare Full vs Stepwise Regression on Sample (n=50) and Population (N=209).
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

% Define Predictors (Cols 3-8) and Response (Col 9)
X_all = full_data(:, 3:8);
Y_all = full_data(:, 9);

% Variable Names for clarity
varNames = {'MYCT', 'MMIN', 'MMAX', 'CACH', 'CHMIN', 'CHMAX'};

% Parameters
N = size(X_all, 1);
n_sample = 50;

% --- 2. Select Random Sample (n=50) ---
rand_indices = randperm(N, n_sample);
X_sample = X_all(rand_indices, :);
Y_sample = Y_all(rand_indices);

% --- 3. Analyze Sample (n=50) ---
fprintf('----------------------------------------------------------------\n');
fprintf('ANALYSIS FOR SAMPLE (n=%d)\n', n_sample);
fprintf('----------------------------------------------------------------\n');
[statsFull_S, statsStep_S, formula_S] = Group7Exe9Fun1(X_sample, Y_sample, varNames);

fprintf('%-15s | %-10s | %-10s | %-10s\n', 'Model', 'MSE (Var)', 'R2', 'Adj R2');
fprintf('%-15s | %10.2f | %10.4f | %10.4f\n', 'Full (6 vars)', statsFull_S.MSE, statsFull_S.R2, statsFull_S.AdjR2);
fprintf('%-15s | %10.2f | %10.4f | %10.4f\n', 'Stepwise', statsStep_S.MSE, statsStep_S.R2, statsStep_S.AdjR2);
fprintf('Stepwise Model Formula: %s\n\n', formula_S);


% --- 4. Analyze Population (N=209) ---
fprintf('----------------------------------------------------------------\n');
fprintf('ANALYSIS FOR POPULATION (N=%d)\n', N);
fprintf('----------------------------------------------------------------\n');
[statsFull_P, statsStep_P, formula_P] = Group7Exe9Fun1(X_all, Y_all, varNames);

fprintf('%-15s | %-10s | %-10s | %-10s\n', 'Model', 'MSE (Var)', 'R2', 'Adj R2');
fprintf('%-15s | %10.2f | %10.4f | %10.4f\n', 'Full (6 vars)', statsFull_P.MSE, statsFull_P.R2, statsFull_P.AdjR2);
fprintf('%-15s | %10.2f | %10.4f | %10.4f\n', 'Stepwise', statsStep_P.MSE, statsStep_P.R2, statsStep_P.AdjR2);
fprintf('Stepwise Model Formula: %s\n\n', formula_P);

fprintf('----------------------------------------------------------------\n');

% --- 5. Comments and Conclusions ---
%
% COMMENTS ON RESULTS (Based on Output):
%
% 1. Improvement over Simple Regression:
%    - In Exercise 8 (Simple Regression with MYCT), the R2 was very low (~0.23).
%    - In Exercise 9 (Multiple Regression), the R2 skyrocketed to ~0.92 (Sample) 
%      and ~0.86 (Population).
%    - Conclusion: CPU Performance is driven by a combination of factors (Memory, 
%      Cache, Channels), not just Cycle Time. The multivariate model is far superior.
%
% 2. Full vs Stepwise Model:
%    - The Stepwise method achieved almost the same predictive power (R2 ~0.924) 
%      as the Full model (R2 ~0.925), but using fewer variables.
%    - This shows that Stepwise is efficient: it removes noise without losing accuracy.
%
% 3. Consistency of Selected Variables (The Key Question):
%    - Sample (n=50) Selected: MMIN + MMAX + CACH + CHMIN
%    - Population (N=209) Selected: MYCT + MMIN + MMAX + CACH + CHMAX
%    - ARE THEY THE SAME? -> NO.
%    - Difference 1: The population model includes MYCT (Cycle Time), whereas the 
%      sample model dropped it, deeming it insignificant.
%    - Difference 2: The sample picked CHMIN (Min Channels), while the population 
%      picked CHMAX (Max Channels).
%
% GENERAL CONCLUSION:
% While a small random sample (n=50) can build a model with high predictive power 
% (high R2), it is NOT reliable for "Feature Selection". It may fail to identify 
% truly important drivers (like MYCT) that only reveal their significance in the 
% larger population dataset.
