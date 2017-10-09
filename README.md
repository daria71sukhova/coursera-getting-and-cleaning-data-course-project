# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.

To perform the task, `dplyr` and `reshape2` libraries are required.

The R script, `run_analysis.R`, does the following:

* 1. Download the dataset if it does not already exist in the working directory
* 2. Load the activity and feature info
* 3. Loads both the training and test datasets
* 4. Select only those columns which contain a mean or standard deviation
* 5. Loads the activity and subject data for each dataset, and merges those
     columns with the dataset
* 6. Merges the two datasets
* 7. Converts the `activity` and `subject` columns into factors
* 8. Creates a tidy dataset with the average of each variable for each activity and each subject.

The result is in the file `average_dataset.txt`.

_In this course project I have used the base of code and README from `bgentry`: `https://github.com/bgentry/coursera-getting-and-cleaning-data-project/blob/master/`_
