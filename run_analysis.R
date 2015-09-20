
fnm <- "gc.zip"

#download the zip file
if(!file.exists(fnm)){

  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
  download.file(url, fnm )
  
}

#unzip the file
if(file.exists(fnm)){ unzip(fnm) }


#get activity labels
 actLab <- read.table("UCI HAR Dataset/activity_labels.txt")
 actLab[,2] <- as.character(actLab[,2])
 
 #get features
 features <- read.table("UCI HAR Dataset/features.txt")
 features[,2] <- as.character(features[,2])
 
 # Extract only the data on mean and standard deviation
 featuresneed <- grep(".*mean.*|.*std.*",features[,2])
 featuresneed.names <- features[featuresneed,2]
 
 featuresneed.names = gsub("-mean", "Mean",featuresneed.names)
 featuresneed.names = gsub("-std","Std",featuresneed.names)
 featuresneed.names <- gsub('[-()]', '', featuresneed.names)
 
 # load train datasets
 Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
 Ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
 trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
 
 train <- cbind(trainSubject, Ytrain, Xtrain)
 
 # load test datasets
 Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
 Ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
 testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
 
 test <- cbind(testSubject, Ytest, Xtest)
 
 # Mere datasets
 alldata <- rbind(train,test)
 
 # add labels
 colnames(alldata) <- c("subject","activity",featuresneed.names)
 
 # turn activities & subjects into factors
 alldata$subject <- as.factor(alldata$subject)
 alldata$activity = factor(alldata$activity , levels = actLab[,1], labels = actLab[,2] )
 
 alldata.melted <- melt(alldata, id= c("subject","activity"))
 alldata.mean <- dcast(alldata.melted, subject + activity ~ variable, mean)
 
 write.table(alldata.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
 
 
 
 