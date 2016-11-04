

#Download data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip data
unzip(zipfile="Dataset.zip",exdir="./data")

# Reading train tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading test tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading features table
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Reading activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

#Assigning column Names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <-c("activityId", "activityType")


# Merging the dataset
merge_train <- cbind(subject_train,x_train,y_train)
merge_test <- cbind(subject_test,x_test,y_test)
merge_train_test <- rbind(merge_train,merge_test)

colNames <- colnames(merge_train_test)



#Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)
setMeanAndStd <- merge_train_test[ , mean_and_std == TRUE]



#Uses descriptive activity names to name the activities in the data set
setWithActivityNames <- merge(setMeanAndStd, activity_labels,by = 'activityId',all.x=TRUE)



#From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.
TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames,mean)

#order by subject and activity
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

#create text file
write.table(TidySet, "TidySet.txt", row.name=FALSE)

