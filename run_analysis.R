setwd("./download/")

# load Train
train = read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
train[,(ncol(train))+1] = read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
train[,(ncol(train))+1] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)

# then load test
test = read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
test[,(ncol(test))+1] = read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
test[,(ncol(test))+1] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

actLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)

# prepare features (column name)
feat = read.csv("download/UCI HAR Dataset/features.txt", sep = "", header = FALSE)

# merge Train + Test
data <- rbind(train,test)

# pick only mean() and std() columns
desiredCols <- grep("*-mean[^Freq]()|*-std()",feat[,2])
desiredFeat <- feat[desiredCols,]

# adding column label + subject to desiredCols and create desiredData set with col.name
desiredCols <- c(desiredCols,(ncol(data)-1),ncol(data))
desiredData <- data[,desiredCols]
colnames(desiredData) <- c(as.character(desiredFeat[,2]), "activity", "subject")

# give name to activity
i <- 1
for(actName in actLabels[,2])  {
  desiredData$activity <- gsub(i, actName, desiredData$activity)
  i <- i + 1
}


# write tidy.txt with mean of 2 variables
desiredData$activity <- as.factor(desiredData$activity)
desiredData$subject <- as.factor(desiredData$subject)

tidyData <- aggregate(desiredData[,1:(ncol(desiredData)-2)], by = list(activity = desiredData$activity, subject = desiredData$subject), mean)
write.table(tidyData, "tidy.txt", sep = "\t", eol = "\n", row.names = FALSE)