% Group7Exe1Prog1.m
% Program to analyze CPU performance attributes and compare sample PDFs with population PDF.
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

clc;
clear;
close all;

% --- 1. Load Data ---
filename = 'CPUperformance.xlsx';

% Check if file exists
if isfile(filename)
    full_data = xlsread(filename); 
else
    error('File CPUperformance.xls not found in the current folder.');
end

% Indices of the columns we need to analyze:
% 3: MYCT (machine cycle time)
% 6: CACH (cache memory)
% 7: CHMIN (minimum channels)
columns_to_analyze = [3, 6, 7];
col_names = {'MYCT', 'CACH', 'CHMIN'};

% Parameters
N_total = size(full_data, 1); % Should be 209
n_sample = 100;               % Sample size
M_iterations = 50;            % Number of iterations

% --- 2. Process each attribute ---
figure('Name', 'Group 7 - Exercise 1', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 400]);

for i = 1:length(columns_to_analyze)
    col_idx = columns_to_analyze(i);
    current_data = full_data(:, col_idx);
    
    % Define Bin Edges for consistency
    % We calculate bins based on the total population range so all M plots align.
    % We use approx 15 bins or Freedman-Diaconis rule. Here we use 20 for detail.
    min_val = min(current_data);
    max_val = max(current_data);
    num_bins = 20; 
    edges = linspace(min_val, max_val, num_bins + 1);
    
    % Create subplot
    subplot(1, 3, i);
    hold on;
    title(['Attribute: ' col_names{i}]);
    xlabel('Value');
    ylabel('Probability Density (PDF)');
    
    % --- Loop M times (Samples) ---
    for j = 1:M_iterations
        % Call the function
        [pdf_vals, centers] = Group7Exe1Fun1(current_data, n_sample, edges);
        
        % Plot the sample curve (Thin Cyan/LightBlue lines)
        plot(centers, pdf_vals, 'Color', [0.6, 0.8, 1, 0.5], 'LineWidth', 1);
    end
    
    % --- Plot Total Population PDF ---
    [total_pdf, ~] = histcounts(current_data, edges, 'Normalization', 'pdf');
    bin_centers = (edges(1:end-1) + edges(2:end)) / 2;
    
    % Plot population curve (Thick Red/Dark line)
    h_total = plot(bin_centers, total_pdf, 'r-', 'LineWidth', 2.5);
    
    % Add a dummy handle for the samples to make the legend correct
    h_sample = plot(nan, nan, 'Color', [0.6, 0.8, 1], 'LineWidth', 1); 
    
    legend([h_total, h_sample], {'Population (N=209)', 'Samples (n=100)'});
    grid on;
    hold off;
end

% --- 3. Comments and Conclusions ---
%
% COMMENTS ON RESULTS:
% 
% 1. MYCT (Machine Cycle Time):
%    - The distribution is highly right-skewed (positive skewness). 
%    - Most values are concentrated at the lower end (fast cycle times).
%    - The M sample curves (n=100) generally follow the shape of the population 
%      curve, but there is variance in the peaks due to random sampling.
%    - Approximation: It resembles an Exponential distribution or a Gamma distribution.
%
% 2. CACH (Cache Memory):
%    - Also right-skewed but with specific spikes (multimodal) because cache 
%      sizes usually come in powers of 2 (e.g., 32, 64, 128).
%    - The sample curves capture the main trend but might miss specific peaks 
%      if the sample doesn't pick up those specific discrete values.
%    - Approximation: Doesn't fit a simple continuous distribution perfectly due 
%      to its discrete nature, but generally follows an exponential decay trend.
%
% 3. CHMIN (Minimum Channels):
%    - This data is discrete and very sparse, heavily concentrated near zero/low values.
%    - The sample curves often fluctuate significantly because a few outliers 
%      can change the histogram height drastically in small bins.
%    - Approximation: Resembles a geometric distribution or exponential decay, 
%      but highly concentrated at the minimum value.
%
% GENERAL CONCLUSION:
% With n = 100 (which is approx. 50% of N = 209), the empirical PDFs of the 
% samples converge relatively well to the population PDF. However, for skewed 
% distributions (like these), outliers in the random sample can cause the 
% sample PDF to overestimate or underestimate the tail or the peak compared 
% to the true population.
