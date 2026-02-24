% Group7Exe8Prog1.m
% Program to analyze regression models for CPU Performance (PRP) vs Cycle Time (MYCT).
% Compares Linear, Quadratic, and Cubic models on Sample and Population.
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

% Define Variables
% X = MYCT (Column 3), Y = PRP (Column 9)
X_all = full_data(:, 3);
Y_all = full_data(:, 9);

N = length(X_all);
n_sample = 50;

% --- 2. Select Random Sample (n=50) ---
% randperm creates random indices
rand_indices = randperm(N, n_sample);
X_sample = X_all(rand_indices);
Y_sample = Y_all(rand_indices);

% --- 3. Evaluate Models on SAMPLE ---
degrees = [1, 2, 3];
model_names = {'Linear (Deg 1)', 'Quadratic (Deg 2)', 'Cubic (Deg 3)'};
colors = {'r', 'g', 'b'};

fprintf('----------------------------------------------------------------\n');
fprintf('REGRESSION ANALYSIS ON RANDOM SAMPLE (n=%d)\n', n_sample);
fprintf('----------------------------------------------------------------\n');
fprintf('%-20s | %-10s | %-10s \n', 'Model', 'R2', 'Adj. R2');
fprintf('----------------------------------------------------------------\n');

% Prepare Figures
figure('Name', 'Model Fitting (Sample)', 'Position', [100, 100, 1000, 500]);
subplot(1, 2, 1);
plot(X_sample, Y_sample, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4); 
hold on;
title('Data and Fitted Models (Sample)');
xlabel('MYCT (Cycle Time)'); ylabel('PRP (Performance)');
legend_entries = {'Data'};

figure('Name', 'Residual Analysis (Sample)', 'Position', [150, 150, 1000, 400]);

best_adj_r2 = -inf;
best_degree = 0;

for i = 1:length(degrees)
    d = degrees(i);
    [p, r2, adj_r2, y_pred, std_resid] = Group7Exe8Fun1(X_sample, Y_sample, d);
    
    % Print stats
    fprintf('%-20s | %10.4f | %10.4f \n', model_names{i}, r2, adj_r2);
    
    % Track best model based on Adjusted R2
    if adj_r2 > best_adj_r2
        best_adj_r2 = adj_r2;
        best_degree = d;
    end
    
    % Plot Model Curve (Sorted for correct line plotting)
    figure(1); subplot(1, 2, 1);
    [X_sorted, idx_sort] = sort(X_sample);
    plot(X_sorted, y_pred(idx_sort), 'Color', colors{i}, 'LineWidth', 2);
    legend_entries{end+1} = model_names{i};
    
    % Plot Standardized Residuals
    figure(2); 
    subplot(1, 3, i);
    plot(y_pred, std_resid, 'o', 'Color', colors{i});
    yline(0, 'k--'); % Zero line
    title([model_names{i} ' Residuals']);
    xlabel('Fitted Values'); ylabel('Std. Residuals');
    grid on;
    ylim([-4 4]); % Standard limits for standardized residuals
end

figure(1); subplot(1, 2, 1);
legend(legend_entries, 'Location', 'best');
grid on;

fprintf('----------------------------------------------------------------\n');
fprintf('Selected Best Model for Sample: Degree %d (Adj R2 = %.4f)\n', best_degree, best_adj_r2);
fprintf('----------------------------------------------------------------\n\n');


% --- 4. Apply Best Model to POPULATION (N=209) ---
fprintf('----------------------------------------------------------------\n');
fprintf('APPLYING BEST MODEL (DEG %d) TO POPULATION (N=%d)\n', best_degree, N);
fprintf('----------------------------------------------------------------\n');

[p_pop, r2_pop, adj_r2_pop, y_pred_pop, std_resid_pop] = Group7Exe8Fun1(X_all, Y_all, best_degree);

fprintf('%-20s | %-10s | %-10s \n', 'Model', 'R2', 'Adj. R2');
fprintf('%-20s | %10.4f | %10.4f \n', ['Degree ' num2str(best_degree)], r2_pop, adj_r2_pop);

% Plot Population Results
figure(1); subplot(1, 2, 2);
plot(X_all, Y_all, 'ko', 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerSize', 3); hold on;
[X_all_sorted, idx_pop] = sort(X_all);
plot(X_all_sorted, y_pred_pop(idx_pop), 'r-', 'LineWidth', 2);
title(['Population Fit (Best Model: Deg ' num2str(best_degree) ')']);
xlabel('MYCT'); ylabel('PRP');
legend('Population Data', 'Fitted Model');
grid on;

fprintf('----------------------------------------------------------------\n');


% --- 5. Comments and Conclusions ---
%
% COMMENTS ON MODEL SELECTION & COMPARISON (Based on Output):
%
% 1. Model Selection (Sample):
%    - Comparing the three models, the Cubic model (Degree 3) was selected 
%      because it had the highest Adjusted R-squared (~0.23) compared to 
%      Linear (~0.08) and Quadratic (~0.14).
%    - However, the R-squared value is quite low (only ~23% of variance explained).
%    - Visual Inspection: The scatter plot shows an inverse relationship 
%      (like 1/x) which polynomials struggle to fit well. The Cubic model 
%      even dips below zero (negative performance) at certain points, which 
%      is physically impossible, but mathematically minimized the error.
%
% 2. Residual Analysis:
%    - The residuals in Figure 2 are NOT randomly distributed. They show a 
%      distinct pattern and increasing variance (heteroscedasticity) as values 
%      increase. This confirms that a polynomial model is not the ideal physical 
%      model for this data, even if it's the best among the tested options.
%
% 3. Comparison (Sample vs Population):
%    - Sample Adj R2: ~0.2286
%    - Population Adj R2: ~0.2240
%    - The results are extremely similar. This indicates that our random sample 
%      of n=50 was highly representative. The model derived from the small 
%      sample performs almost identically when applied to the full population.
%
% CONCLUSION:
% While the Cubic model is the best mathematical fit among polynomials, 
% the relationship between Cycle Time and Performance is likely non-linear 
% and non-polynomial (e.g., logarithmic or exponential decay). However, 
% statistically, the sample was sufficient to capture the general trend of the population.
