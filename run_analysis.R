library(plyr)

## Read activity label names and feature names
actlabels <- read.table("activity_labels.txt", as.is=2)
features <- read.table("features.txt", as.is=2)

## Get test data
stest <- read.table("test/subject_test.txt")
ytest <- read.table("test/y_test.txt")
xtest <- read.table("test/X_test.txt")

## Get training data
strain <- read.table("train/subject_train.txt")
ytrain <- read.table("train/y_train.txt")
xtrain <- read.table("train/X_train.txt")

# Merge test and training data
sall <- rbind(stest, strain)
yall <- rbind(ytest, ytrain)
xall <- rbind(xtest, xtrain)

# Update data variable names
names(xall) <- features$V2
names(actlabels) <- c("actid", "activity")
activity <- actlabels[yall[,1],"activity"]
subject <- sall$V1

## Extracts only the measurements on the mean and standard deviation
## for each measurement. 
x_mean_std <- xall[,grep("mean\\(|std\\(", features$V2)]

## Merge subject, activity and selected measurements
data <- cbind(subject, activity, x_mean_std)

## Creates tidy data set with the average of each variable
## for each activity and each subject.
tidydata <- ddply(data, .(subject,activity),numcolwise(mean))

## Save to tidydata.txt
write.table(tidydata, "tidydata.txt", quote=FALSE, row.names=FALSE)

