# Get the current working directory
getwd()

# Set the working directory to "UCI HAR Dataset"


# Read in the activity labels and the features (i.e. variable names for the X dataset)

Activity_labels = read.table("activity_labels.txt")
Features = read.table("features.txt")

# Take a look at these datasets

Activity_labels
Features

head(Activity_labels)
dim(Activity_labels)

head(Features)
dim(Features)

# I want to derive a "Variable Name" dataset from the Features dataset
# I want to transpose the Features dataset and remove V1, so that the 
# dataset is a 1 by 561 matrix with only the variable names

Features_transpose = t(Features)
myvars <- c("V2")
Features_transpose <- Features[myvars]
Features_transpose = t(Features_transpose)

head(Features_transpose)
dim(Features_transpose)
view(Features_transpose)


# Next I want to read in the test and training datasets annd explore them


X_test = read.table("test/X_test.txt")
Y_test = read.table("test/y_test.txt")
Subject_test = read.table("test/subject_test.txt")

dim(X_test)
dim(Y_test)
dim(Subject_test)

head(X_test)
head(Y_test)
head(Subject_test)

str(X_test)
str(Y_test)
str(Subject_test)


X_train = read.table("train/X_train.txt")
Y_train = read.table("train/y_train.txt")
Subject_train = read.table("train/subject_train.txt")

dim(X_train)
dim(Y_train)
dim(Subject_train)

str(X_train)
str(Y_train)
str(Subject_train)


# I want to set the Y variables to factor variables with the levels describing
# the activity being measured

Y_test$V1 <- factor(Y_test$V1)
Y_train$V1 <- factor(Y_train$V1)

levels(Y_test$V1) <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
levels(Y_train$V1) <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")

levels(Y_test$V1)
levels(Y_train$V1)

## Next I need to rename the X, Y and Subject variables

library(plyr)
Y_test <- rename(Y_test, c("V1"="Activity"))
Subject_test <- rename(Subject_test, c("V1"="Subject_ID"))

Y_train <- rename(Y_train, c("V1"="Activity"))
Subject_train <- rename(Subject_train, c("V1"="Subject_ID"))

colnames(X_test) <- Features_transpose
head(X_test)

colnames(X_train) <- Features_transpose
head(X_train)



# Now I need to extract all the mean and standard deviation variables 

grep("mean",Features$V2)
grep("std",Features$V2)

include_variables = grep("mean()|std()",Features$V2)
include_variables

include_variables2 = intersect(grep("mean|std",Features$V2),grep("meanFreq",Features$V2,invert=TRUE))
include_variables2 

dim(Features_transpose)

Features_transpose.2 <- Features_transpose[, include_variables2] 

dim(Features_transpose.2)

X_test.2 <- X_test[, include_variables2] 
dim(X_test.2)
head(X_test.2)


X_train.2 <- X_train[, include_variables2] 
dim(X_train.2)
head(X_train.2)



# Next I want to bind together the Subject, Y and X variables


test_data <- cbind(Subject_test, Y_test, X_test.2)
train_data <- cbind(Subject_train, Y_train, X_train.2)

dim(test_data)
dim(train_data)

head(test_data)

head(train_data)


# Finally merge the test data and the train data. Rbind should work

test_train_data <- rbind(test_data, train_data)
dim(test_train_data)
head(test_train_data)

# Set subjects as factors too

test_train_data$Subject_ID <- factor(test_train_data$Subject_ID)
levels(test_train_data$Subject_ID)


# Write data to a csv file
write.csv(test_train_data, file = "Test_train_data.csv")


# Last step - create a new dataset with the average of each variable for each activity and each subject

final_data = aggregate(test_train_data, list(test_train_data$Subject_ID,test_train_data$Activity), mean)
dim(final_data)
head(final_data)
final_data<- final_data[ -c(3:4) ]
final_data = rename(final_data, c("Group.1"="Subject_ID", "Group.2"="Activity"))

# Write final tidy dataset to a file 

write.table(final_data, file = "Tidy_data.txt", row.names = FALSE)

