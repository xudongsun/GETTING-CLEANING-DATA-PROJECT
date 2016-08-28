# GETTING-CLEANING-DATA-PROJECT

# additional information about the variables and trasformations of the project


# download & unzip the file


# read the files
## activity
activity_test <- read.table(file.path(datarf, "test", "Y_test.txt"), header= FALSE)
activity_train <- read.table(file.path(datarf,"train", "Y_train.txt"), header = FALSE)


## subject
subject_test <- read.table(file.path(datarf, "test", "subject_test.txt"), header = FALSE)
subject_train <- read.table(file.path(datarf, "train", "subject_train.txt"), header = FALSE)

## features
features_test <- read.table(file.path(datarf, "test", "X_test.txt"), header = FALSE)
features_train <- read.table(file.path(datarf, "train", "X_train.txt"), header = FALSE)

# look at the data using str()


# task1 : Merge the data & create new data set
subjectdata <- rbind(subject_train, subject_test)
activitydata <- rbind(activity_train, activity_test)
featuresdata <- rbind(features_train, features_test)

## names
names(subjectdata) <- c("subject")
names(activitydata) <- c("activity")
feature_names <- read.table(file.path(datarf, "features.txt"), header = FALSE)
View(feature_names)
names(featuresdata) <- feature_names$V2

data_sa <- cbind(subjectdata, activitydata)
data_merged <- cbind(data_sa, featuresdata)

# task2 : extract the measurements on the mean and sd for each measurement
mean<- as.character( feature_names$V2[grep("mean()", feature_names$V2, fixed = TRUE )] )
std<- as.character( feature_names$V2[grep("std()", feature_names$V2, fixed = TRUE )] )
select_names <- c(mean, std, "subject","activity")
data <- subset(data_merged, select = select_names)

## check the data frame "data"
View(data)
str(data)

# descriptive activity names
activity_lables <- read.table(file.path(datarf, "activity_labels.txt"), header = FALSE)
data$activity <- factor(data$activity, levels = 1:6, labels = activity_lables$V2)

# labels the data set with descriptive variable names
# ^t = time, Acc = Accelerometer, Gyro = Gyroscope, ^f = frequency
# Mag = Magnitude, BodyBody = Body

names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

names(data)


# create a second tidy data set

data_t <- aggregate(. ~subject + activity, data, FUN = "mean")
data_t <- data_t[order(data_t$subject, data_t$activity),]
write.table(data_t, file = "tidydata.txt", row.names = FALSE)



























