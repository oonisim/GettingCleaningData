#--------------------------------------------------------------------------------
# Read feature names of the data X to use as column names for the data X.
#--------------------------------------------------------------------------------
# 561 features as specified in the features.txt as (id, name) and take only names.
# Tidy names (Do not use regexp reserved characters)
# 1. Replace function name like std() with _std.
# 2. Replacing space, comma, minus, parenthesis with underscore (_).
# 3. Replace ^t with Time_ and ^f with Freq_.
# 4. Replace repeating underscores with one.
# 5. Remove trailing underscore.
#--------------------------------------------------------------------------------
features <- read.csv("features.txt", sep = "", header = FALSE)[, 2]
features <- tolower(features)
features <- gsub("\\-(.+)\\(\\)", "_\\1", features[])
features <- gsub("[() ,-]", "_", features)
features <- gsub("^t", "time_", features)
features <- gsub("^f", "freq_", features)
features <- gsub("__*", "_", features)
features <- gsub("_$", "", features)

#--------------------------------------------------------------------------------
# Read data X with descriptive column names using feature names.
#--------------------------------------------------------------------------------
# There are 561 columns with each feature as specified in the features.txt. 
# Subject of each row X is identified with the label of the corresponding row in subject.
# Activity of each row X is identified with the label of the corresponding row in y.
#--------------------------------------------------------------------------------
x_test <- read.csv("test/X_test.txt", sep = "", col.names = features, colClasses = "numeric", header = FALSE)
x_train <- read.csv("train/X_train.txt", sep = "", col.names = features, colClasses = "numeric", header = FALSE)
X <- rbind(x_test, x_train)

# Extracts mean and std measurements by __mean, and __std.
X <- X[, grepl("_mean|_std", colnames(X))]

#--------------------------------------------------------------------------------
# Read subject of each X row as numeric with a descriptive column name.
#--------------------------------------------------------------------------------
# The experiments have been carried out with a group of 30 volunteers.
# Each volunteer (subject) is identified with label 1-30 specified in subject_<partition>.txt.
#--------------------------------------------------------------------------------
subject_test <- read.csv("test/subject_test.txt", col.names = c("subject"), colClasses = "numeric", header=FALSE)
subject_train <- read.csv("train/subject_train.txt", col.names = c("subject"), colClasses = "numeric", header=FALSE)
subject <- rbind(subject_test, subject_train)

#--------------------------------------------------------------------------------
# Read activity of each X row as numeric with a descriptive column name.
# Replace ID with descriptive activity names.
#--------------------------------------------------------------------------------
# Activity type of each row data in X_<partition> is identified with the label of 
# the corresponding row in y_<partition>.txt.
#
# [Convert ID into descriptive activity name]
# Read activity labels (id, label) and sort by id number 1..n into activity_labels.
# Convert activity_labels(id, label) into a vector activity_labels(label).
# activity_label[<id>] provides the correesponding label and use it for conversion by
# applying a conversion function to X$activity column.
#--------------------------------------------------------------------------------
y_test <- read.csv("test/y_test.txt", col.names = c("activity"), colClasses = "numeric", header=FALSE)
y_train <- read.csv("train/y_train.txt", col.names = c("activity"), colClasses = "numeric", header=FALSE)
activity <- rbind(y_test, y_train)

# Convert activity id to label.
activity_labels=read.csv("activity_labels.txt", sep="", col.names = c("id", "label"), colClasses = c("numeric", "character"), header=FALSE)
activity_labels <- activity_labels[order(activity_labels$id),2]
activity$activity <- sapply(activity$activity, function(id){activity_labels[id]})

#--------------------------------------------------------------------------------
# Merge subject and activity with data X
#--------------------------------------------------------------------------------
X <- cbind(subject, activity, X)

#--------------------------------------------------------------------------------
# Use dplyr to group by (subject, activity) and get mean for each data column.
#--------------------------------------------------------------------------------
library("dplyr")
means <- tbl_df(X) %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
View(means)
write.table(as.data.frame(means), "means.txt", row.names = FALSE)
