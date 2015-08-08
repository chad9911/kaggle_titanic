# this script aims at filling in the missing data in the original trainnig and testing
# dataset through imputation.

load("train_modified.RData")
load("test_modified.RData")

# load mice library

library(mice)

# Imputation through default pmm method

imp_test <- mice(test, m = 5)
imp_train <- mice(train, m = 5)

test <- complete(imp_test,include = T)
train <- complete(imp_train,include = T)

# save back as RDate

save(train,file = "train_modified.RData")
save(test,file = "test_modified.RData")