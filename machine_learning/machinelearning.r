
library(caret)
library(rattle)

training<-read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv", na.strings = c("NA","","#DIV/0!"))
testing<-read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",
                  na.strings = c("NA","","#DIV/0!"))

# Remove features with no values
t<-training[,-1:-7]
t<-t[, colSums(is.na(t)) < 1900]
nearZero<-nearZeroVar(t, saveMetrics = TRUE)
dim(t)

# Choosing features
c<-cor(t[,-length(t)])
correlated<-findCorrelation(c, cutoff=0.8)

t<-t[, -correlated]

# Setting cross validation test

inTrain<-createDataPartition(training$classe, p = 0.70, list = FALSE)
train_data<-t[inTrain,]
test_data<-t[-inTrain,]

# Fitting models


#Tree
tree<-train(classe ~., data=train_data, method="rpart")
fancyRpartPlot(tree$finalModel)

tree_predict<-predict(tree,test_data$classe)
tree_cm<-confusionMatrix(tree_predict,test_data$classe)

#GBM
gbm<-train(classe ~., data=train_data, method="gbm", trControl = fitControl)
gbm_predict<-predict(gbm,test_data$classe)
gbm_cm<-confusionMatrix(gbm_predict,test_data$classe)


#RandomForest
cluster <- makeCluster(detectCores() - 1) # convention to leave 1 core for OS
registerDoParallel(cluster)
fitControl <- trainControl(method = "cv",
                           number = 10,
                           allowParallel = TRUE)
rf<-train(classe ~., data=train_data, preprocess=c("center","scale"), method="rf",trControl = fitControl)
rf_predict<-predict(rf,test_data$classe)
rf_cm<-confusionMatrix(rf_predict,test_data$classe)
stopCluster(cluster)
registerDoSEQ()


# lda

lda<-train(classe ~., data=train_data, preprocess=c("center","scale"), method="lda",trControl = fitControl)
rf_predict<-predict(lda,test_data)
lda_cm<-confusionMatrix(lda_predict,test_data$classe)

# SVM

ctrl <- trainControl(method = "repeatedcv", repeats = 10)
svm <- train(classe~., data=train_data, preprocess=c("center","scale"), method = "svmLinear", trControl = ctrl)
