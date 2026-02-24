% Group7Exe10Prog1.m
% Program to compare Full, PCR, and LASSO models for specific CPU Vendors.
% Evaluates MSE on a 35% Test set (Split 65% Train / 35% Test).
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

% Data Columns:
% Col 1: Vendor Code (numeric ID of manufacturer)
% Cols 3-8: Predictors (Attributes)
% Col 9: Response (PRP)

vendor_codes = full_data(:, 1);
unique_vendors = unique(vendor_codes);

fprintf('------------------------------------------------------------------------------\n');
fprintf('  MODEL COMPARISON BY VENDOR (Train 65%% / Test 35%%)\n');
fprintf('  Criterion for PCR: >90%% Variance | Criterion for LASSO: MinCV MSE\n');
fprintf('------------------------------------------------------------------------------\n');
fprintf('%-10s | %-10s | %-12s | %-12s | %-12s\n', 'Vendor ID', 'Samples(N)', 'MSE Full', 'MSE PCR', 'MSE LASSO');
fprintf('------------------------------------------------------------------------------\n');

% --- 2. Iterate through each Vendor ---
for i = 1:length(unique_vendors)
    v_id = unique_vendors(i);
    
    % Extract data for this vendor
    idx_vendor = (vendor_codes == v_id);
    data_vendor = full_data(idx_vendor, :);
    
    n_samples = size(data_vendor, 1);
    
    % Check constraint: Size > 10
    if n_samples > 10
        
        X = data_vendor(:, 3:8);
        y = data_vendor(:, 9);
        
        % --- 3. Split Data (65% Train, 35% Test) ---
        % Using cvpartition for randomized split
        c = cvpartition(n_samples, 'HoldOut', 0.35);
        idx_train = training(c);
        idx_test = test(c);
        
        X_train = X(idx_train, :);
        y_train = y(idx_train);
        X_test  = X(idx_test, :);
        y_test  = y(idx_test);
        
        % --- 4. Call Function to Evaluate Models ---
        [mse_full, mse_pcr, mse_lasso] = Group7Exe10Fun1(X_train, y_train, X_test, y_test);
        
        % --- 5. Print Results ---
        fprintf('%-10d | %-10d | %12.2f | %12.2f | %12.2f\n', ...
            v_id, n_samples, mse_full, mse_pcr, mse_lasso);
    end
end
fprintf('------------------------------------------------------------------------------\n');

% --- 6. Comments and Conclusions ---
%
% COMMENTS ON RESULTS (Based on Output Table):
%
% 1. The Problem of Small Sample Size:
%    - Most vendors grouped here have very small sample sizes (N between 12 and 32).
%    - With 6 predictors and only ~12-20 observations, the Full Linear Model 
%      suffers heavily from overfitting. It fits the training noise rather than 
%      the signal, leading to high MSE on the Test set.
%
% 2. LASSO Superiority (Case Study: Vendor 11):
%    - For Vendor 11 (N=12), the Full Model MSE is ~1027, while LASSO MSE is ~324.
%    - This huge improvement implies that the true model is "sparse". Only a few 
%      hardware attributes matter for this vendor. LASSO successfully identified 
%      them and zeroed out the irrelevant ones, drastically reducing error.
%
% 3. PCR Superiority (Case Study: Vendor 8):
%    - For Vendor 8 (N=32), PCR achieved the lowest error (~895) compared to 
%      Full (~1747) and LASSO (~1706).
%    - This suggests high multicollinearity among the predictors. PCR condensed 
%      the correlated variables into principal components, capturing the variance 
%      without the instability of the Full Model.
%
% GENERAL CONCLUSION:
% When N is small relative to the number of variables (p), dimensionality reduction 
% techniques are essential. 
% - Use LASSO when you suspect only a few variables are important (Feature Selection).
% - Use PCR when variables are correlated and you want to summarize them.
% - Avoid the Full Linear Model in these cases as it lacks generalization power.
