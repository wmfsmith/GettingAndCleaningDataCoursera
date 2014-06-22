# Project.R
# Class projecdt for Getting and Cleaning Data

# data.table has some good things
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

# First, set working directory and read general info.

setwd("~/Google Drive/Coursera classes/Getting and cleaning data/UCI HAR Dataset")
features <- read.table("features.txt")
act.labels <- read.table("activity_labels.txt")


# Now, the test data.  Use the features read above to name the test data columns.  Then
# add activity and subject columns and make them factors

test_values <- values <- read.table("test/X_test.txt", col.names=features$V2)
test_subjects <- read.table("test/subject_test.txt")
test_values$subject <- test_subjects$V1
test_activity <- read.table("test/y_test.txt")
test_values$activity <- as.factor(test_activity$V1)

# Training
train_values <- values <- read.table("train/X_train.txt", col.names=features$V2)
train_subjects <- read.table("train/subject_train.txt")
train_values$subject <- train_subjects$V1
train_activity <- read.table("train/y_train.txt")
train_values$activity <- as.factor(train_activity$V1)

# Merge -- this is the first requirement
all.data <- rbind(test_values, train_values)

# Get only the mean and std values
# Easy query with data table
features.DT <- data.table(colnames(all.data))
good.features <- features.DT[V1 %like% "mean" | V1 %like% "std" |
                               V1 == "activity" | V1 == "subject"]

# Filtered data -- second requirement
all.data.filtered <- all.data[ good.features$V1]

# Name activities - third requirement
levels(all.data.filtered$activity) <- act.labels$V2

# Pretty up names - 4th requirement
# Change initial "t" to "TimeDomain."
names(all.data.filtered) <- gsub("^t", "TimeDomain.", names(all.data.filtered))
# Change inital "f" to "FrequencyDomain."
names(all.data.filtered) <- gsub("^f", "FrequencyDomain.", names(all.data.filtered))
# Chance "Acc" to "Acceleration"
names(all.data.filtered) <- gsub("Acc", "Acceleration", names(all.data.filtered))# Change "std" to "stddev"
names(all.data.filtered) <- sub("std", "stddev", names(all.data.filtered))
# Condense multiple periods before X, Y and Z
names(all.data.filtered) <- sub("\\.+([XYZ])$", ".\\1",  names(all.data.filtered))
# Remove final periods
names(all.data.filtered) <- sub("\\.+$", "",  names(all.data.filtered))

# Save
write.table(all.data.filtered, file = "tidy_data_1.txt", sep = ",", row.names = F)
# Test
read.all.data <- read.table("tidy_data_1.txt", header=T, sep=",")
print(paste("Column names match -", 
            all(colnames(read.all.data) ==  colnames(all.data.filtered))))
print(paste("Row counts match -",
            nrow(all.data.filtered) == nrow(read.all.data)))

# Create 2nd data set of means, aggregated by subject and activity.  Note that we assume
# that the "subject" and "activity" columns are the two last, and that the order is
# subject, activity
subject.col.index <- which(colnames(all.data.filtered) == "subject")
agg <- aggregate( all.data.filtered[,1:(subject.col.index - 1)], 
                  all.data.filtered[,subject.col.index:(subject.col.index + 1)], 
                  FUN = mean )
# Make the subject an integer so it sorts well
agg$subject <- as.integer(agg$subject)
# Sort by activity and subject
agg.sorted <- agg[with(agg, order(activity, subject)), ]
# Rename columns to show actual value.  Note that the grouping columns
# are at the front now.
agg.columns <- 3:ncol(agg.sorted)
names(agg.sorted)[agg.columns] <- paste(names(agg.sorted)[agg.columns], ".grouped.mean", sep = "")

# Save
write.table(agg.sorted, file = "tidy_data_2.txt", sep = ",", row.names = F)
# Test
read.agg.data <- read.table("tidy_data_2.txt", header=T, sep=",")
print(paste("Column names match -", 
            all(colnames(read.agg.data) ==  colnames(agg.sorted))))
print(paste("Row counts match -",
            nrow(read.agg.data) == nrow(agg.sorted)))
