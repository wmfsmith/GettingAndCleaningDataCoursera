---
title: "Code Book - Class Project -- Getting and Cleaning Data"
author: "Bill Smith"
date: "June 22, 2014"
output: html_document
---

This document provides a Code Book for the scripts and output files for the Getting and Cleaning Data class project.

### Input Data

#### Data are found in a directory hierarchy.

##### Top level

`activity_labels.txt` maps numbers to text activity values, such as "WALKING."

`features.txt` list the features to be found in the data sets.

Directories `test` and `train` contain the actual data.

Results are written here.

##### subdirectory `test`

Contains the `test` subset of the data, 3 files plus a subdirectory containing raw data used to generate feature values.  The 3 files all have the same number of rows.

I made assumptions about how the data are organized.

`X_test.txt` contains the actual feature data as a ASCII file of numeric values.  I've assumed it is a matrix of feature values, rows as measurement events and columns as features.  The number of columns matches the number of rows in the top level `features.txt` file, so I assumed that the contents of the `features.txt` file define the features in `X_test.txt.`

`subject_test.txt` is a file with one integer value per row.  I assumed that it identifies the test subject associated with each row in the `X_test.txt` file.

`y_test.txt` is a file with one integer value per row.  The integers vary from 1 through 6, so I assume that they identify the activity associated with each row in the `X_test.txt` file and are mapped to an understandable value via the top level `activity_labels.txt` file.

##### subdirectory `train`

Organized exactly as `test.`

### Script

#### Important variables

#### Lines 1 - 31 read in the data.

Read first the top level activity and feature info, then the test and train data sets.

The values from the `features.txt` file are applied as column names for the data from `X_test.txt,` which is read into a data frame.  Activity and subject values are read from their respective files and added as columns in the main data frame.

Finally, the two data frames are merged into one.

#### Lines 33 - 40 filter the data

Columns which contain the strings "std" or "mean" are identified.  We make a new data frame with only those columns, plus "activity" and "subject

#### Line 43 names the activities

Using the labels from `activity_labels.txt,` we transform the integer activity values into strings.

#### Lines 45 - 56 prettify the column labels

Columns are renamed *en masse*, substituting "TimeDomain" for initial "t," "FrequencyDomain" for initial "f, "stddev" for "std," and "Acceleration" for "acc."  Periods introduced by using the feature names with illegal characters are removed.

#### Lines 58 - 65 save/test the first tidy data set

We save the data frame, then read it back in and do some basic comparisons to make sure that the conversion to a text file didn't break anything.

#### Lines 67 - 81 group values by subject and activity and compute mean values.

We aggregate the data using columns "subject" and "activity," computing the means of other columns' values.  We rename the newly generated columns to show "grouped.mean" to distinguish from the mean values already there.  We sort by "subject" and "activity" to make the table easier to review.

#### Lines 83 - 90 save/test the second tidy data set

We save the data frame, then read it back in and do some basic comparisons to make sure that the conversion to a text file didn't break anything.




