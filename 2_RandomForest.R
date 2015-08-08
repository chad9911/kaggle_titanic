load("train_modified.RData")
load("test_modified.RData")

# Load party package for conditional inference tree training

library(party)

# train random forest model with cleaned training set.
## set seed for reproducibility

set.seed(220)

formula <- as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + 
        Embarked + Title + FamilySize + FamilyID

forest_fit <- cforest(formula, data = train, controls=cforest_unbiased(ntree=2000, mtry=3))


# using the newly trained rf model, predict survivial flag with testing set.

my_prediction <- predict(forest_fit,test,OOB=T,type="response")

# create data frame with predicted survival flag with the format to accord with
# the requirement of submission.

my_solution <- data.frame(PassengerId = test$PassengerId, Survived = as.vector(my_prediction))

# produce csv file ready for submission
write.csv(x = my_solution, file = "my_solution.csv", row.names = F)
