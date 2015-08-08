
##### Data cleaning and variable engineering #####

# load in train and test sets
train <- read.csv("train.csv")
test <- read.csv("test.csv")

# train and test are available in the workspace
str(train)
str(test)

# variable engineering

test$Survived <- NA
combi <- rbind(train,test)
combi$Name <- as.character(combi$Name)
combi$Title <- sapply(combi$Name,FUN=function(x){
        strsplit(x,split='[,.]')[[1]][2]})
combi$Title <- sub(' ','',combi$Title)
combi$Title <- factor(combi$Title)

combi$FamilySize <- combi$SibSp + combi$Parch + 1

combi$Surname <- sapply(combi$Name, FUN=function(x) {
        strsplit(x, split='[,.]')[[1]][1]})

combi$FamilyID <- paste(as.character(combi$FamilySize), combi$Surname, sep="")

combi$FamilyID[combi$FamilySize <= 2] <- 'Small'
famIDs <- data.frame(table(combi$FamilyID))
famIDs <- famIDs[famIDs$Freq <= 2,]
combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
combi$FamilyID <- factor(combi$FamilyID)

train <- combi[1:891,]
test <- combi[892:1309,]

# save as RDate

save(train,file = "train_modified.RData")
save(test,file = "test_modified.RData")