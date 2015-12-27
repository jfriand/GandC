setwd("~/Documents/Rhw")
training = read.csv("train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("train/subject_train.txt", sep="", header=FALSE)

testing = read.csv("test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("activity_labels.txt", sep="", header=FALSE)

# Clean Feature Names
features = read.csv("features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge
allData = rbind(training, testing)

# Get only stats
cols1 <- grep(".*Mean.*|.*Std.*", features[,2])
# Reduce Features
features <- features[cols1,]
# Add Columns (subject and activity)
cols1 <- c(cols1, 562, 563)
# remove unwanted
allData <- allData[,cols1]
# Add the column names
colnames(allData) <- c(features$V2, "Activity", "Subject")
colnames(allData) <- tolower(colnames(allData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}

allData$activity <- as.factor(allData$activity)
allData$subject <- as.factor(allData$subject)

tidy = aggregate(allData, by=list(activity = allData$activity, subject=allData$subject), mean)
# Clean Columns
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidytest.txt", sep="\t")