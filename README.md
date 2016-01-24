## Getting and Cleaning Data Course Project

### Objective
From the data from the study of Human Activity Recognition Using Smartphones Data Set, generate mean values of the measurement of the mean and standard deviation features grouped by (subject, activity). 

See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) for the study.


### Usage
* Download https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip it to your working directory
* Make sure folder structure and files below are created. 
UCI HAR Dataset
|-- activity_labels.txt
|-- features.txt
|-- test/
|-- train/
* Change the working directory to UCI HAR Dataset
* Place run_analysis.R script the directory.
* In R console, run `source("run_analysis.R")`, it may take a few seconds

### Results
1. Result view of mean values of each variable (grouped by subject, activity) in R.
2. Result file means.txt is created in the directory.
