## Getting and Cleaning Data Course Assignment

Code Book for run_analysis.R

This cook book explians how the run_analysis.R created the tidydata.txt.

For information about the scripts please refer to README.md.

Human Activity Recognition Using Smartphones Dataset Version 1.0 Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. 
Smartlab - Non Linear Complex Systems Laboratory? degli Studi di Genova. Via Opera Pia 11A, I-16145, Genoa, Italy. activityrecognition@smartlab.ws www.smartlab.ws

Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 
Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The obtained dataset was partitioned into two sets, training data and test data.

The data contained 128 measurements derived from sensor signals accelerometer and gyroscope. 

##Processing Steps

1. Merged the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the dataset in step 4, create tidydata.txt, an independent tidy data set with the average of each variable for each activity and each subject.

Subject: Integer 1:30 - Subject unique id number
Activity: One of the following activities WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
66 numeric feature variables, each with the average value of the mean or standard deviation for the feature variables from the original set.


# The following is the code that was used to produce the tidy data.

# Download the file and put the file in the data folder.

if(!file.exists("./wk4data")){dir.create("./wk4data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./wk4data/Dataset.zip")

# Unzip the file

unzip(zipfile="./wk4data/Dataset.zip",exdir="./wk4data")

# get the names of the files from the folder UCI HAR.

dir <- file.path("./wk4data" , "UCI HAR Dataset")
filesnames<-list.files(dir, recursive=TRUE)
filesnames

# Get the Activity files.

activitytest  <- read.table(file.path(dir, "test" , "Y_test.txt" ),header = FALSE)
activitytrain <- read.table(file.path(dir, "train", "Y_train.txt"),header = FALSE)

# Get the Subject files.

subjecttrain <- read.table(file.path(dir, "train", "subject_train.txt"),header = FALSE)
subjecttest  <- read.table(file.path(dir, "test" , "subject_test.txt"),header = FALSE)

# Get Features files.

featuretest  <- read.table(file.path(dir, "test" , "X_test.txt" ),header = FALSE)
featuretrain <- read.table(file.path(dir, "train", "X_train.txt"),header = FALSE)

# Check above values.

##str(activitytest)

##str(activitytrain)

##str(subjecttrain)

##str(subjecttest)

##str(featuretest)

##str(featuretrain)

# Merges the training and test to create one dataset.


subject <- rbind(subjecttrain, subjecttest)
activity <- rbind(activitytrain, activitytest)
features <- rbind(featuretrain, featuretest)

# set featuresnames names to description.

names(subject)<-c("subject")
names(activity)<- c("activity")
featuresnames <- read.table(file.path(dir, "features.txt"),head=FALSE)
names(features)<- featuresnames$V2

# Combine all columns to get all data into one dataframe.

allcombined <- cbind(subject, activity, features)

# Get columns with names of features that contain mean() or std().

subfeaturesnames<-featuresnames$V2[grep("mean\\(\\)|std\\(\\)", featuresnames$V2)]

# Subset the dataframe by seleted names of features.

selectedNames<-c(as.character(subfeaturesnames), "subject", "activity" )
allcombined<-subset(allcombined,select=selectedNames)

# Check the dataframe allcombined

##str(allcombined)

# Read descriptive activity names from activity_labels.txt.

activitylabels <- read.table(file.path(dir, "activity_labels.txt"),header = FALSE)

# Change activity code in the allcombined dataframe using activity names

allcombineda <- sqldf("select a.*,l.V2 as 'activity2' from allcombined a, activitylabels l where a.activity = l.V1")
drops <- c("activity")
allcombineda <- allcombineda[ , !(names(allCombineda) %in% drops)]
colnames(allcombineda)[68] <- "activity"

# Check

##head(Data$activitya,30)

# Names of features more descriptive names.

names(allcombineda) <- gsub("^t", "time ", names(allcombineda))
names(allcombineda) <- gsub("^f", "frequency ", names(allcombineda))
names(allcombineda) <- gsub("Acc", "Accelerometer ", names(allcombineda))
names(allcombineda) <- gsub("Gyro", "Gyroscope ", names(allcombineda))
names(allcombineda) <- gsub("Mag", "Magnitude ", names(allcombineda))
names(allcombineda) <- gsub("BodyBody", "Body ", names(allcombineda))
names(allcombineda) <- gsub("Body", "Body ", names(allcombineda))
names(allcombineda) <- gsub("Gravity", "Gravity ", names(allcombineda))
names(allcombineda) <- gsub("Jerk", "Jerk ", names(allcombineda))
names(allcombineda) <- gsub(".)", "", names(allcombineda))
names(allcombineda) <- gsub(".(", "", names(allcombineda))
names(allcombineda) <- gsub("-", " ", names(allcombineda))
names(allcombineda) <- gsub("  ", " ", names(allcombineda))

# make a new tidy dataset with the average of each activity and subject.

library(plyr);
allcombinedb <- aggregate(. ~subject + activity, allcombineda, mean)
allcombinedb <- allcombinedb[order(allcombinedb$subject,allcombinedb$activity),]
write.table(allcombinedb, file = "tidydata.txt",row.name=FALSE)

# Prouduce Markdown file.



