function p_value = Group7Exe2Fun1(dataVector, n)
% Group7Exe2Fun1 Performs Chi-Square Goodness-of-Fit test on a random sample.
%
% INPUTS:
%   dataVector: The full column of data (population)
%   n:          The sample size to select
%
% OUTPUTS:
%   p_value:    The p-value resulting from the Chi-Square test for Normality.
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % 1. Randomly select n observations
    total_N = length(dataVector);
    random_indices = randperm(total_N, n);
    sample_data = dataVector(random_indices);

    % 2. Perform Chi-Square Goodness-of-Fit test for Normal Distribution
    % chi2gof checks the null hypothesis that data comes from a normal distribution.
    [~, p_value] = chi2gof(sample_data);

end
