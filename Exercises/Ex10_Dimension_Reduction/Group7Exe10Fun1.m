function [mse_full, mse_pcr, mse_lasso] = Group7Exe10Fun1(X_train, y_train, X_test, y_test)
% Group7Exe10Fun1 Fits Full, PCR, and LASSO models and calculates MSE.
%
% INPUTS:
%   X_train, y_train: Training data (65%)
%   X_test, y_test:   Testing data (35%)
%
% OUTPUTS:
%   mse_full:  Mean Squared Error for Full Linear Regression
%   mse_pcr:   Mean Squared Error for Principal Component Regression
%   mse_lasso: Mean Squared Error for LASSO Regression
%
% TEAM MEMBERS:
%   1. [Alexandros Galazoulas 10629]
%   2. [Asterios Poulios 10887]

    %% 1. Full Linear Regression Model
    % Train model
    mdlFull = fitlm(X_train, y_train);
    % Predict on test set
    y_pred_full = predict(mdlFull, X_test);
    % Calculate MSE
    mse_full = mean((y_test - y_pred_full).^2);


    %% 2. Principal Component Regression (PCR)
    % Step A: Standardize Data (Important for PCA)
    mu = mean(X_train);
    sigma = std(X_train);
    
    % Handle case where sigma is 0 (constant column) to avoid NaN
    sigma(sigma==0) = 1; 

    X_train_std = (X_train - mu) ./ sigma;
    X_test_std  = (X_test - mu)  ./ sigma;

    % Step B: Perform PCA on Training Data
    [coeff, scoreTrain, ~, ~, explained] = pca(X_train_std);

    % Step C: Dimensionality Reduction Criterion
    % Keep components that explain at least 90% of variance
    cumVar = cumsum(explained);
    num_comps = find(cumVar >= 90, 1, 'first');
    if isempty(num_comps), num_comps = size(X_train, 2); end

    % Step D: Regress Y on the selected Principal Components
    % Add column of ones for the intercept
    X_train_pca = [ones(size(scoreTrain,1),1), scoreTrain(:, 1:num_comps)];
    beta_pcr = X_train_pca \ y_train;

    % Step E: Predict on Test Data
    % Project test data onto the same principal components
    scoreTest = X_test_std * coeff(:, 1:num_comps);
    X_test_pca = [ones(size(scoreTest,1),1), scoreTest];
    y_pred_pcr = X_test_pca * beta_pcr;

    % Calculate MSE
    mse_pcr = mean((y_test - y_pred_pcr).^2);


    %% 3. LASSO Regression
    % Step A: Use Cross-Validation to find optimal Lambda
    % We use 'CV', 5 (5-fold) because sample sizes per vendor are small.
    [B, FitInfo] = lasso(X_train, y_train, 'CV', 5);

    % Step B: Select coefficients for the Lambda with Minimum MSE
    idxLambda = FitInfo.IndexMinMSE;
    beta_lasso = B(:, idxLambda);
    intercept_lasso = FitInfo.Intercept(idxLambda);

    % Step C: Predict on Test Data
    y_pred_lasso = X_test * beta_lasso + intercept_lasso;

    % Calculate MSE
    mse_lasso = mean((y_test - y_pred_lasso).^2);

end
