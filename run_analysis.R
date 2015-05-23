#Merges the training and the test sets to create one 
#data set.

train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_s <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_s <- read.table("./UCI HAR Dataset/test/subject_test.txt")
data_s <- rbind(train_s,test_s)
data_y <- rbind(train_y,test_y)
data_x <- rbind(train_x,test_x)
names(data_s) <- "subject"
names(data_y) <- "activity"
features <- read.table("./UCI HAR Dataset/features.txt")
names(data_x) <- features$V2
data_set <- cbind(data_s,data_y,data_x)

#Extracts only the measurements on the mean and 
#standard deviation for each measurement. 
sub_names <- features$V2[grep("mean\\(\\)|std\\(\\)",features$V2)]
sub_names_f <- c("subject","activity",as.character(sub_names))
data <- subset(data_set,select = sub_names_f)

#Uses descriptive activity names to name the activities 
#in the data set
onlabel <- read.table("./UCI HAR Dataset/activity_labels.txt")
data$activity <- factor(data$activity,labels = onlabel[,2])


#Appropriately labels the data set with descriptive variable names. 

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))


#From the data set in step 4, creates a second, independent tidy data
#set with the average of each variable for each activity and each subject.

library(plyr)
data_t <- aggregate(. ~subject + activity,data,mean)
write.table(data_t, file = "tidydata.txt",row.name=FALSE)

