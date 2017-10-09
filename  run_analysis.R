library(dplyr)
library(reshape2)
filename <- "dataset.zip"
# download and unzip the archive:
if(!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method = "curl")
}

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename)
}
# create objects with all labels and features:*
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", as.is = TRUE)
features <- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)

# extract only the data of mean and standart deviation:*
featuresMeanStd <-grep(".*mean.*|.*std.*", features[,2]) 
featuresMeanStd.names <-features[featuresMeanStd,2]

# create the appropriate variable names:
featuresMeanStd.names <- gsub("-mean", "Mean", featuresMeanStd.names)#*
featuresMeanStd.names <- gsub("-std", "Std", featuresMeanStd.names)#*
featuresMeanStd.names <- gsub("[-()]", "", featuresMeanStd.names)#*
featuresMeanStd.names <- gsub("^t", "time", featuresMeanStd.names)#**
featuresMeanStd.names <- gsub("^f", "frequency", featuresMeanStd.names)#**
featuresMeanStd.names <- gsub("Acc", "Accelerometer", featuresMeanStd.names)#**
featuresMeanStd.names <- gsub("Gyro", "Gyroscope", featuresMeanStd.names)#**
featuresMeanStd.names <- gsub("Mag", "Magnitude", featuresMeanStd.names)#**
featuresMeanStd.names <- gsub("BodyBody", "Body", featuresMeanStd.names)#**

# read data from the train dataset:
train <- read.table("train/X_train.txt")
trainActivities <- read.table("train/y_train.txt")
trainSubject <- read.table("train/subject_train.txt")

# take the essential data from the test dataset:
train <- train %>% select(featuresMeanStd) %>% cbind(trainSubject, trainActivities, .)


# read data from the test dataset:
test <- read.table("test/X_test.txt")
testActivities <- read.table("test/y_test.txt")
testSubject <- read.table("test/subject_test.txt")

# take the essential data from the train dataset:
test <- test %>% select(featuresMeanStd) %>% cbind(testSubject, testActivities, .)

# merge the datasets
allData <- rbind(train, test)

# name the variables
colnames(allData) <- c("subject", "activity", featuresMeanStd.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

# create new tidy dataset with the average of each variable for each activity and each subject:
allData_melted <- melt(allData, id = c("subject","activity"))
allData_mean <- dcast(allData_melted, subject+activity ~ variable, mean)
write.table(allData_mean, "average_dataset.txt", row.names = FALSE, quote = FALSE)

##
# * - the approach is taken form bgentry: https://github.com/bgentry/coursera-getting-and-cleaning-data-project/blob/master/
# ** - the approach is taken from https://rstudio-pubs-static.s3.amazonaws.com/37290_8e5a126a3a044b95881ae8df530da583.html

