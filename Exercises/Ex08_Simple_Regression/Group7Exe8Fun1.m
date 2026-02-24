function [p, R2, AdjR2, y_pred, std_residuals] = Group7Exe8Fun1(x, y, degree)
% Group7Exe8Fun1 Fits a polynomial regression model and calculates metrics.
%
% INPUTS:
%   x:      The independent variable (Predictor)
%   y:      The dependent variable (Target)
%   degree: The degree of the polynomial (1=Linear, 2=Quadratic, etc.)
%
% OUTPUTS:
%   p:             Polynomial coefficients
%   R2:            Coefficient of Determination
%   AdjR2:         Adjusted Coefficient of Determination
%   y_pred:        The predicted values based on the model
%   std_residuals: Standardized residuals for diagnostic check
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % 1. Fit Polynomial Model
    % p contains coefficients [a_n, ..., a_1, a_0]
    [p, S] = polyfit(x, y, degree);
    
    % 2. Predict values
    y_pred = polyval(p, x);
    
    % 3. Calculate Residuals
    residuals = y - y_pred;
    
    % 4. Calculate R-squared (R2)
    y_mean = mean(y);
    SST = sum((y - y_mean).^2);  % Total Sum of Squares
    SSR = sum(residuals.^2);     % Sum of Squared Residuals
    R2 = 1 - (SSR / SST);
    
    % 5. Calculate Adjusted R-squared (AdjR2)
    n = length(y);
    k = degree + 1; % Number of parameters (coefficients)
    % Formula: 1 - (1-R2)*((n-1)/(n-k))
    % Note: Using n-k for denominator where k includes the intercept term
    AdjR2 = 1 - ((1 - R2) * (n - 1) / (n - k));
    
    % 6. Calculate Standardized Residuals
    % We divide residuals by their standard deviation
    std_residuals = residuals / std(residuals);

end
