# Predicting-Churn-Data
The program creates a model to predict the Churn dat of customers from a Telco Company
The dataset was taken from here: https://www.kaggle.com/blastchar/telco-customer-churn

A few notes however for the following program:
  1. The data has some missing values. These were imputed using mice function from the mice package. However, I used the quickpred function to impute the missing data due to it being faster.
  2. The model is built using the glmnet method.
  3. The file used in the program already has imputed values and the imputation procedure has been commented out in the code.
