function p_value = Group7Exe3Fun1(dataVector, n)
% Group7Exe3Fun1 Performs Two-Sample Kolmogorov-Smirnov test.
% Checks if the random sample of size n comes from the same distribution
% as the full population (dataVector).
%
% INPUTS:
%   dataVector: The full column of data (population, N=209)
%   n:          The sample size to select (e.g., 40)
%
% OUTPUTS:
%   p_value:    The p-value of the test (H0: distributions are the same).
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % 1. Randomly select n observations
    total_N = length(dataVector);
    random_indices = randperm(total_N, n);
    sample_data = dataVector(random_indices);

    % 2. Perform Two-Sample Kolmogorov-Smirnov test
    % Compares the empirical CDF of sample_data with the empirical CDF of dataVector.
    % H0: The two samples come from the same continuous distribution.
    [~, p_value] = kstest2(sample_data, dataVector);

end
