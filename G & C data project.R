library(dplyr)
library(knitr)

if(!file.exists("./projectdata")){
        dir.create("./projectdata")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile="./projectdata/dataset.zip", mode = "wb")

# unzip the file
unzip(zipfile = "./projectdata/dataset.zip", exdir = "./projectdata")
datarf <- file.path("./projectdata", "UCI HAR Dataset")
files <- list.files(datarf, recursive = TRUE)

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

# look at the data
str(activity_test)
# 'data.frame':	2947 obs. of  1 variable:
# $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

str(activity_train)
# 'data.frame':	7352 obs. of  1 variable:
# $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

str(subject_test)
# 'data.frame':	2947 obs. of  1 variable:
# $ V1: int  2 2 2 2 2 2 2 2 2 2 ...

str(subject_train)
# 'data.frame':	7352 obs. of  1 variable:
# $ V1: int  1 1 1 1 1 1 1 1 1 1 ...

str(features_test)
# 'data.frame':	2947 obs. of  561 variables:
#         $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
# $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
# $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
# $ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
# $ V5  : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
# [list output truncated]

str(features_train)
# 'data.frame':	7352 obs. of  561 variables:
#         $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
# $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
# $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
# $ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
# $ V5  : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
# [list output truncated]

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






























































