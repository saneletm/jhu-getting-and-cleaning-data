# GETTING AND CLEANING DATA - ASSIGNMENT

This is the assignment projet for JHU-Datascience Getting and Cleaning data course.
The source script `run_analysis.R` does is not unittested. So... it hopefully works.
This is what it should do:

1. There are 3 main functions
    * get_data()  -- Checks if it should download data, or used data on disk
    * merge_data(data_type) -- merge all the components of `data_type` -- train OR test.
        * merge_data has two internal functions:
            * make_path -- creates the path to the file to be read
            * read_data -- reads the file given the path
    * run_analysis() -- could have just been named `run/main` if 
        the name `run_analysis` was not required

2. Cleaning/tidying
    * Read `features` from  `features.txt`
    * Read `activity_labels` from `activity_labels.txt`
    * For each data_source (test/train)
        * read x_data, y_data, and subject_data
        * x_data names <- features[, 2]
        * y_data names <- 'activity'
        * convert y_data 'activity' column to a factor with labels from activity_labels column 2
        * cbind subject_data, y_data, and x_data
        * using grep, return only data related to `mean` and `standard diviation`
    * Get an aggregate of means for all variables grouping by `subjectId` and `activity`
    * Order tidy data by `subjectId` and `activity`
    * Write tidy data to `tidy_data.txt`