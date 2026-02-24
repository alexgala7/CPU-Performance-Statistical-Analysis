# Data Analysis: CPU Performance Study | Group 7

This repository contains a comprehensive statistical analysis of CPU performance data, based on the Kibler & Aha (1988) dataset. The project covers a wide range of statistical methods, from exploratory data analysis to advanced predictive modeling.

## 📊 Project Overview
The analysis is performed on a dataset of 209 observations across 9 variables, including manufacturer codes, cycle times, memory capacity, and published performance (PRP).

### Key Methodologies
* **Exploratory Data Analysis:** Empirical Probability Density Functions (PDF) and histogram modeling.
* **Hypothesis Testing:** Chi-square ($X^2$) goodness-of-fit, Student's t-tests, and Correlation testing.
* **Resampling Techniques:** Bootstrap methods for confidence interval estimation.
* **Regression Modeling:** Simple and Multiple Linear Regression, including Stepwise selection.
* **Advanced Modeling:** Principal Component Regression (PCR) and LASSO for dimensionality reduction.

## 📂 Implementation Structure
The project is divided into 10 distinct exercises. Each exercise follows a consistent dual-file structure:
* **`Group7ExiFun1.m`**: The core function implementing the statistical logic.
* **`Group7ExiProg1.m`**: The main script that loads data, calls the function, and generates visualizations.

*(Where `i` denotes the exercise number from 1 to 10).*

## 📈 Key Results

### 1. Distribution & Correlation
Detailed analysis of variables like `MYCT`, `CACH`, and `CHMIN` to determine their underlying distributions and inter-correlations using Fisher transformations.

### 2. Comparative Manufacturer Performance
A comparative study of different manufacturers to identify statistically significant differences in mean performance using both parametric and bootstrap approaches.

### 3. Predictive Model Selection
Comparison of full linear models against reduced-dimension models (PCR, LASSO) using Mean Squared Error (MSE) on a 35% validation set.

## 🛠️ Requirements
* MATLAB (Statistics and Machine Learning Toolbox recommended)
* `CPUPerformance.xls` data file

---
*Developed as part of the Data Analysis course, ECE AUTh.*
