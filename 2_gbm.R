load("train_modified.RData")
load("test_modified.RData")

# Load party caret for gbm trainning

library(caret)

# train gbm model with cleaned training set.
## set seed for reproducibility

set.seed(220)

formula <- as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + 
        Embarked + Title + FamilySize + FamilyID

gbmControl <- trainControl(method = "repeatedcv", number = 10, repeats = 2)
grid = expand.grid(interaction.depth = seq(2,20,b=2),
                   n.trees = seq(50,3000,by=50),
                   shrinkage=c(0.1),
                   n.minobsinnode=c(5))

gbm.fit <- train(formula,data=train,method = "gbm",trControl = gbmControl, tuneGrid = grid)


# using the newly trained gbm model, predict survivial flag with testing set.

pre <- data.frame(Prediction = predict(gbm.fit,test))
my_solution <- data.frame(PassengerId = test$PassengerId, Survived = pre$Prediction)

# create data frame with predicted survival flag with the format to accord with
# the requirement of submission.

my_solution <- data.frame(PassengerId = test_imp$PassengerId, Survived = pre$Prediction)

# produce csv file ready for submission

write.csv(x = my_solution, file = "my_solution.csv", row.names = F)


