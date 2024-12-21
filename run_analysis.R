## GETTING AND CLEANING DATA - FINAL PROJECT FILE NAMED "run_analysis.R"


## 0) SETS WORKING DIRECTORY - MAKE SURE IT IS THE SAME AS "getwd()" in R 
setwd("C:/Users/user/Dropbox/Education/Coursera/JH Data Science/GETTING AND CLEANING DATA/FINAL PROJECT")
## DOWNLOAD PROJECT DATA FOUND ON COURSE WEBSITE - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## THIS WILL PUT "getdata_projectfiles_UCI HAR Dataset.zip" in MyDocuments
## MOVE "UCI HAR DATASET" FOLDER TO THE WORKING DIRECTORY
## unzip("UCI HAR Dataset.zip") ## UNZIPS ZIP FILE
## CREATES "test" folder, "train" folder, and "activity_labels", "features", "features_info", and "READ_ME" text files.

## 1) READS DATA INTO R
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt") ## imports the different types of activities into R
features<-read.table("UCI HAR Dataset/features.txt") ## reads the features data (i.e., "tBodyAcc-mean()-X") into R

train_set<-read.table("UCI HAR Dataset/train/X_train.txt") ## Reads training set into R
train_labels<-read.table("UCI HAR Dataset/train/y_train.txt") ## Reads training labels (1-6) into R
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt") ## Reads subject who performed training activity (1-30) into R

test_set<-read.table("UCI HAR Dataset/test/X_test.txt") ## Reads test set into R
test_labels<-read.table("UCI HAR Dataset/test/y_test.txt") ## Reads test labels (1-6) into R
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt") ## Reads subject who performed test activity (1-30) into R


## 2) COMBINES TRAIN AND TEST DATA
combined_set<-rbind(train_set, test_set)## Combines train and test sets
combined_labels<-rbind(train_labels, test_labels)## Combines train and test labels
combined_subject<-rbind(train_subject, test_subject)## Combines train and test subjects


## 3) EXTRACTS ONLY FEATURES WHICH ANALYZE MEANS OR STANDARD DEVIATIONS
features_mean_only<-grep("-mean()", as.character(features$V2), fixed=TRUE) ## A vector of integers - selects only the features data containing "mean".
## Setting fixed=TRUE does not allow () to be interpreted as a meta-character. I am eliminating all fields with "meanFreq", by doing this, as these are not truly means.
features_std_only<-grep("-std()", as.character(features$V2), fixed=TRUE) ## A vector of integers - selects only the features data containing "std" = same rationale as above.
features_mean_or_std<-sort(c(features_mean_only, features_std_only)) ## A vector of integers - selects only the features data containing either "mean" or "std". 


## 4) CREATES FINAL WORKING DATA SET - NAMED "set"
set<-cbind(combined_subject, combined_labels, combined_set[features_mean_or_std]) ## The set we will be working with with columns combined and only means and stds included - short name for this reason


## 5) CREATION OF TIDY DATA SET
tidydata<-aggregate(set[3:68], by=set[1:2], mean) ## Gets aggregate of data by test subject ID and activity
colnames(tidydata)<-c("Subject.ID","Activity", as.character(features[features_mean_or_std, 2])) ## Labels all columns
tidydata<-tidydata[with(tidydata, order(Subject.ID, Activity)), ] ## Puts the data in order by "Subject.ID and "Activity".
tidydata[ ,"Activity"]<-activity_labels[tidydata[ ,"Activity"], 2] ## Puts text of activity in colmun 2 (labeled "Activity") of the output.


## 6) WRITES TABLE TO "tidydata.txt"
write.table(tidydata, file="tidydata.txt", sep="\t", row.names = FALSE) ## Writes the data to a file named "tidydata.txt", not incorporating row.names


## 7) READS DATA FROM "tidydata.txt" BACK TO "data_final".
data_final<-read.table("tidydata.txt") ## Reads the "tidydata.txt" file back into R
View(data_final)


