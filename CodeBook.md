# CodeBook

This codeBook describes the variables, the data, and the work performed to clean up the data and create the tidy data set: `tidy.txt`.

## The Assignment

The original data was cleaned up following the assigned task of the course work:

1. Merging the training and the test sets to create one data set.
2. Extracting only the measurements on the mean and standard deviation for each measurement. 
3. Using descriptive activity names to name the activities in the data set
4. Appropriately labeling the data set with descriptive activity names. 
5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 

## The variables:
The original data set describes the followed variables:
* `x_train`, `y_train`, `x_test`, `y_test`, `subject_train` and `subject_test` which contain the data from the downloaded files.

## There are two identifiyers 
* `subject` which contani the ID of the test subject
* `activity` which describes The type of activity performed when the corresponding measurements were taken: `WALKING` (ID-1); `WALKING_UPSTAIRS` (ID-2); `WALKING_DOWNSTAIRS` (ID-3); `SITTING` (ID-4); `STANDING` (ID-5); `LAYING` (ID-6)

# The R script:

Here is described the R script `run_analysis.R` according to assignment tasks of the course work:

## Download data
Below is the code used to download and unzip the data set:

`fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "getdata.zip", method="curl")
unzip("getdata.zip")`

## Load data set and organize the data
Below is the code used to load the data set from the `test`data set: subject, features and activity

`subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
feature_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
activity_test <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)`

Below is the code used to load data set from the `trainning` data set: subject, features and activity

`subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
feature_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
activity_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)`

The code below combine subject, features and activity from `trainning` and `test` data set

`subject <- rbind(subject_test, subject_train)
feature <- rbind(feature_test, feature_train)
activity <- rbind(activity_test, activity_train)`

## Clean up the data according to the assignment tasks
The code below change the class labels for a descriptive activity names (assignment task #3)

`labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
activity$V1 <- factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)`

The code below label apropriately the data set with descriptive variable names (assignemnt task #4)

`feature_label <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
names(feature) <- feature_label$V2
names(activity) <- c("activity")
names(subject) <- c("subject")`

The code below extract only the measurements on the mean and sandard deviation (std) for each measurement (assignment task #2)

`means_std <- c(as.character(feature_label$V2[grep(".*mean.*|.*std.*", feature_label$V2)]))
measurements <- subset(feature,select = means_std)`

The code below merges the data sets to create one data set (assignment task #1)

`final_dataset <- cbind(subject, activity, measurements)`

The code below create a independent tidy dataset calle `tidy.txt` with average of each variable for each activity and subject (assignemnt task #5)

`tidy_dataset <- aggregate(final_dataset[,3:81], by = list(subject = final_dataset$subject, activity = final_dataset$activity), FUN = mean)
write.table(tidy_dataset, "tidy.txt", row.names = FALSE)`
