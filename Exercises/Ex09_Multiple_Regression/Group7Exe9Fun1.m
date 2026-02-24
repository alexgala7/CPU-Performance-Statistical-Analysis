function [statsFull, statsStep, stepVars] = Group7Exe9Fun1(X, y, varNames)
% Group7Exe9Fun1 Fits Full and Stepwise Linear Regression models.
%
% INPUTS:
%   X: Matrix of predictor variables (columns 3-8)
%   y: Vector of response variable (PRP)
%   varNames: Cell array with names of the predictors (for display)
%
% OUTPUTS:
%   statsFull: Struct containing MSE, R2, AdjR2 for the Full Model
%   statsStep: Struct containing MSE, R2, AdjR2 for the Stepwise Model
%   stepVars:  The names of the variables selected by the stepwise method
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    % --- 1. Full Linear Model (Uses all predictors) ---
    % We combine X and y into a standard call for fitlm
    % 'ResponseVar' is the last name in the list usually, but fitlm handles X,y separate too.
    mdlFull = fitlm(X, y, 'VarNames', [varNames, {'PRP'}]);
    
    statsFull.MSE = mdlFull.MSE;           % Error Variance
    statsFull.R2 = mdlFull.Rsquared.Ordinary;
    statsFull.AdjR2 = mdlFull.Rsquared.Adjusted;
    
    % --- 2. Stepwise Linear Regression ---
    % Starts with a constant model and adds/removes terms (linear)
    % 'Verbose', 0 suppresses the step-by-step output in Command Window
    mdlStep = stepwiselm(X, y, 'constant', 'Upper', 'linear', ...
                         'VarNames', [varNames, {'PRP'}], 'Verbose', 0);
                     
    statsStep.MSE = mdlStep.MSE;
    statsStep.R2 = mdlStep.Rsquared.Ordinary;
    statsStep.AdjR2 = mdlStep.Rsquared.Adjusted;
    
    % Get selected variable names (excluding the response 'PRP')
    % Coefficients table includes Intercept, so we check predictor names used.
    stepVars = mdlStep.VariableNames(1:end-1); 
    % Note: fitlm/stepwiselm objects keep track of used variables internally.
    % A safer way to see active terms is from the Formula or Coefficients.
    % However, 'VariableNames' in the object usually lists all involved. 
    % We will extract the formula string to show the user which vars were kept.
    stepVars = mdlStep.Formula; 

end
