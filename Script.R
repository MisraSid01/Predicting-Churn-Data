library(purrr)
library(qdap)
library(dplyr)
library(magrittr)
library(ggplot2)
library(tibble)
library(caret)
library(glmnet)
library(caTools)
library(mice)

# Extracting data from file
set.seed(42)
TelcoCust <- read.csv("TelcoCust_Churn2.csv", header = TRUE)

# Exploratory Analysis of Data
missing_data <- map(TelcoCust, ~ sum(is.na(.)))
mean_data <- map(TelcoCust, ~ mean(., na.rm = FALSE))

# This section is commented due to the fact that imputation were already run once and new file is used for modeling
# I used quickpred because system was unable to handle the normal mice predictions. used random minpuc value here 

# -----------------------------------------------------------------------------------------------------------------------
# Imputing Missing values
# miceImpute <- mice(TelcoCust_old, pred = quickpred(TelcoCust_old, minpuc = 0.3))
# TelcoCust <- complete(miceImpute)
# write.csv(TelcoCust, "TelcoCust_Churn2.csv")
# ------------------------------------------------------------------------------------------------------------------------
# Plotting
customers <- ggplot(TelcoCust, aes(x = gender, color = gender)) + geom_bar(width = 0.40) + labs(title = "Gender of Customers",
           x = "Gender", y = "No. of People", color = "Gender")
print(customers)

billings <- ggplot(TelcoCust, aes(x = MonthlyCharges, y = TotalCharges)) + geom_jitter(color = "red") + labs(title = "Monthly Charges vs Total Charges",
                   x = "Monthly Charges", y = "Total Charges")
print(billings)

# Randomizing and Splitting Dataset
sample_dataset <- sample(nrow(TelcoCust))
TelcoCust <- TelcoCust[sample_dataset,]

cust_split <- round(nrow(TelcoCust) * 0.75)
cust_train <- TelcoCust[(1:cust_split),]
cust_test <- TelcoCust[(cust_split + 1):nrow(TelcoCust),]

# Training the Dataset
ownControl <- trainControl(method = "cv", number = 8,
                          verboseIter = TRUE, classProbs = TRUE)
model_1 <- train(Churn ~ . - customerID, cust_train,
                 method = "glmnet", metric = "ROC",
                trControl = ownControl)

print(model_1)
# Testing the trained model
model1_test <- predict(model_1, cust_test)
print(confusionMatrix(model1_test, cust_test$Churn))



