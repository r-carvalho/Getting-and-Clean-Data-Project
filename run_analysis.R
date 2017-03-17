library(reshape2)

## Download and unzip the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "getdata.zip", method="curl")
unzip("getdata.zip")

## Load data set from test (subject, features and activity)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
feature_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
activity_test <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)

## Load data set from trainning (subject, features and activity)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
feature_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
activity_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)

## Combine subject, features and activity data set
subject <- rbind(subject_test, subject_train)
feature <- rbind(feature_test, feature_train)
activity <- rbind(activity_test, activity_train)

## Change the class labels for descriptive activity names (#3)
labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
activity$V1 <- factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)

## Label apropriately the data set with descriptive variable names (#4)
feature_label <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
names(feature) <- feature_label$V2
names(activity) <- c("activity")
names(subject) <- c("subject")

## Extract only the measurements on the mean and std for each measurement (#2)
means_std <- c(as.character(feature_label$V2[grep(".*mean.*|.*std.*", feature_label$V2)]))
measurements <- subset(feature,select = means_std)

## Merge the data sets to create one data set (#1)
final_dataset <- cbind(subject, activity, measurements)

## Create a independent tidy dataset with average of each variable for each activity and subject (#5)
tidy_dataset <- aggregate(final_dataset[,3:81], by = list(subject = final_dataset$subject, activity = final_dataset$activity), FUN = mean)
write.table(tidy_dataset, "tidy.txt", row.names = FALSE)

