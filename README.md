# Tidy-Data
## Coursera: Getting and Cleaning Data Project 

This repo contains two files:

The first file is a codebook explaining the dataset created by the R scipt.

The second file is the R script.

The R script does the following:

1) Read in the activity labels and the features (i.e. variable names for the X dataset)

2) It derives a "Variable Name" dataset from the Features dataset

3) It reads in the test and training datasets 

4) It sets the Y variables to factor variables with the levels describing the activity being measured

5) It renames the X, Y and Subject variables as appropriate

6) It extracts all the mean and standard deviation variables

7) It binds together the Subject, Y and X variables for both the training and test data

8) Next it merges the test data and the train data

9) Creates a new dataset with the average of each variable for each activity and each subject

10) Finally it writes a dataset to a file "Tidy_data.txt" 
