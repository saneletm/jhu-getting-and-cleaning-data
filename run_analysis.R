library(dplyr)
library(tidyr)


# TODO: readme and the other doc
# TODO : count file lines

get_data <- function () {
   if (!file.exists("./UCI HAR Dataset/")){
       
       print ("Downloading data ...")
       download.file(
           "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
           destfile = "./data.zip",
           method = "curl"
       )
       print ("Unziping data ...")
       unzip("./data.zip", exdir = "./")
   }
   else{
       print ("Using data already on disk")
   }
} 

merge_data <- function (data_type, row_count){
    features <- read.table("./UCI HAR Dataset/features.txt")
    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
    
    make_path <- function (path_prefix){
        file_ext <- ".txt"
        base_path <- paste("./UCI HAR Dataset/", data_type, sep="")
        paste(base_path, path_prefix, data_type , file_ext, sep = "")
    }
    
    read_file <- function (file_path) {
       print (paste ("Reading: ", file_path))
       read.table(file_path, nrows = row_count) 
    }
    
    x_data <- read_file(make_path("/X_"))
    y_data <- read_file(make_path("/y_"))
    subject_data <- read_file(make_path("/subject_"))
    
    # rename columns
    names(x_data) <- as.character(features[,2])
    names(y_data) <- "activity"
    names(subject_data) <- "subjectId"
    colnames(activity_labels) <- c('activityId', 'activityType')
    
    # merge data
    y_data$activity <- factor(y_data$activity, labels = activity_labels$activityType)
    merged_data <- cbind(subject_data, y_data, x_data)
    
    # get mean/std boolean vector
    colNames <- names(merged_data)
    has_mean_or_std <- grep("mean|std|activity|subjectId", colNames, value=T)
    cleaned_data <- merged_data[, has_mean_or_std]
}

run_analysis <- function () {
   get_data()
   train_row_count = 7352
   test_row_count = 2947
   
   train_data <- merge_data("train", train_row_count)
   test_data <- merge_data("test", test_row_count)
   
   all_data <- rbind(train_data, test_data)
   print("Summarizing data ...")
   tidy_data <- aggregate(. ~subjectId + activity, all_data, mean)
   tidy_data <- tidy_data[order(tidy_data$subjectId, tidy_data$activity), ]
   
   # write to file   
   print ("writing tidy data to file ...")
   write.table(tidy_data, "./resulting_tidy_data.txt", row.name=FALSE)
   print ("done!")
}
