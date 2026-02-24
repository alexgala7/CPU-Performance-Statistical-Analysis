function [pdf_values, bin_centers] = Group7Exe1Fun1(dataVector, n, edges)
% Group7Exe1Fun1 Calculates the empirical PDF of a random sample.
%
% INPUTS:
%   dataVector: The full column of data (population)
%   n:          The sample size to select
%   edges:      The vector of bin edges for the histogram (for consistent plotting)
%
% OUTPUTS:
%   pdf_values: The calculated probability density values
%   bin_centers: The centers of the bins (for plotting x-axis)
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % 1. Randomly select n observations
    % We use randperm to generate random indices
    total_N = length(dataVector);
    random_indices = randperm(total_N, n);
    sample_data = dataVector(random_indices);

    % 2. Calculate empirical PDF using the histogram method
    % We use 'histcounts' with 'Normalization', 'pdf' to get density directly.
    [pdf_values, ~] = histcounts(sample_data, edges, 'Normalization', 'pdf');

    % Calculate bin centers for plotting
    bin_centers = (edges(1:end-1) + edges(2:end)) / 2;

end
