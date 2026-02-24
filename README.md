# Data Analysis: CPU Performance Study | Group 7

A comprehensive statistical study and predictive modeling project based on the Kibler & Aha (1988) CPU dataset, implemented in MATLAB. The analysis covers the full data science pipeline: from exploratory statistics and hypothesis testing to advanced regression and dimensionality reduction.

## 📊 Project Overview
The analysis is performed on a dataset of 209 observations across 9 variables, including cycle times, memory capacity, and Published Performance (PRP).

### Key Methodologies
* **Exploratory Data Analysis:** Empirical PDF modeling and histogram fitting.
* **Hypothesis Testing:** Chi-square ($X^2$) goodness-of-fit, Student's t-tests, and Correlation testing.
* **Resampling Techniques:** Bootstrap methods for robust confidence interval estimation.
* **Predictive Modeling:** Simple, Multiple Linear, and Polynomial Regression.
* **Advanced Selection:** Principal Component Regression (PCR) and LASSO regularization.

## 📈 Key Results & Visualizations

### 1. Distribution & Modeling (Ex. 1-2)
Detailed analysis to determine underlying distributions. We used Chi-square tests to validate the fit of theoretical models to empirical data, such as cycle time and cache memory.

![Distribution Fit](Plots/cpu_distribution_fit.png)


### 2. Manufacturer Benchmarking (Ex. 5)
Using **Bootstrap resampling**, we compared the Published Performance (PRP) across different hardware manufacturers. The boxplot analysis helped identify statistically significant performance differences and outliers.

![Manufacturer Comparison](Plots/manufacturer_comparison_boxplot.png)


### 3. Regression & Diagnostic Analysis (Ex. 8-9)
We evaluated various regression models to capture the dependency of PRP on technical specifications. The comparison between linear and polynomial fits helped identify the optimal model complexity.

![Regression Fit](Plots/regression_model_fit.png)

*Figure: Comparison of Linear, Quadratic, and Cubic models on sample data (left) and the final 3rd-degree polynomial model (right).*

### 4. Predictive Model Selection (Ex. 10)
To address multicollinearity and improve generalization, we compared the Full Linear Model against PCR and LASSO on a 35% validation set.

| Modeling Strategy | MSE (Validation Set) | Key Advantage |
| :--- | :---: | :--- |
| **Full Linear Model** | *[Τιμή]* | Baseline accuracy |
| **PCR** | *[Τιμή]* | Multicollinearity mitigation |
| **LASSO** | *[Τιμή]* | Feature sparsity & selection |

## 📂 Repository Structure
The project is divided into 10 distinct exercises. Each folder follows a modular dual-file structure:

* 📂 **`Exercises/`**: Subfolders `Ex01` to `Ex10` containing:
    * 📄 `Group7ExiFun1.m`: The core function implementing the statistical logic.
    * 📄 `Group7ExiProg1.m`: The main script for data loading and plotting.
* 📂 **`Data/`**: Contains `CPUPerformance.xlsx`.
* 📂 **`Plots/`**: High-resolution visualization highlights.

## 🛠️ Tech Stack
* **Language:** MATLAB
* **Toolboxes:** Statistics and Machine Learning Toolbox
* **Data:** Kibler & Aha (1988) CPU Dataset

---
*Developed as part of the Data Analysis course, ECE AUTh, 2026.*
