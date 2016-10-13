---
title: "Homework 3"
layout: page
permalink: /homework3/
---



## DUE: 10/28


## Homework Submission

Please build your R package either into a `.tar.gz` file or to a `.zip` file and upload the file to the dropbox on Courseplus. Make sure your package passes all checks without any errors or warnings before uploading.


## Longitudinal Data Class and Methods

The purpose of this part is to create a new class for representing longitudinal data, which is data that is collected over time on a given subject/person. This data may be collected at multiple visits, in multiple locations. You will need to write a series of generics and methods for interacting with this kind of data. 

The data for this assignment are the same data you used for Homework 2. You can download the dataset here:

* [Homework 3 data](MIE.zip)

Before doing this part you may want to review the lecture on object oriented programming (you can also [read that section here](https://bookdown.org/rdpeng/RProgDA/object-oriented-programming.html))

The variables in the dataset are

* id: the subject identification number
* visit: the visit number which can be 0, 1, or 2
* room: the room in which the monitor was placed
* value: the level of pollution in micrograms per cubic meter
* timepoint: the time point of the monitor value for a given visit/room

You will need to design a class called "LongitudinalData" that describes the structure of this longitudinal dataset. You will also need to design classes to represent the concept of a "subject", a "visit", and a "room".

In addition you will need to implement the following functions

* `make_LD`: a constructor function that converts a data frame into a "LongitudinalData" object

* `subject`: a generic function for extracting subject-specific information

* `visit`: a generic function for extracting visit-specific information

* `room`: a generic function for extracting room-specific information

For each generic/class combination you will need to implement a method, although not all combinations are necessary (see below). You will also need to write print and summary methods for some classes (again, see below).

To complete this Part, you can use either the S3 system or the S4 system to implement the necessary functions. It is probably not wise to mix any of the systems together, but you should be able to compete the assignment using any of the three systems. The amount of code required should be the same when using any of the systems.




For this assessment, you will need to implement the necessary functions to be able to execute the following code and to produce the associated output. The output of your function does not need to match *exactly*, but it should convey the same information. 


```r
## Read in the data
library(readr)
library(magrittr)
## Load any other packages that you may need to execute your code

data <- read_csv("data/MIE.csv")
x <- make_LD(data)
print(class(x))
```

```
[1] "LongitudinalData"
```

```r
print(x)
```

```
Longitudinal dataset with 10 subjects 
```

```r
## Subject 10 doesn't exist
out <- subject(x, 10)
print(out)
```

```
NULL
```

```r
out <- subject(x, 14)
print(out)
```

```
Subject ID: 14 
```

```r
out <- subject(x, 54) %>% summary
print(out)
```

```
ID: 54 
  visit  bedroom       den living room    office
1     0       NA        NA    2.792601 13.255475
2     1       NA 13.450946          NA  4.533921
3     2 4.193721  3.779225          NA        NA
```

```r
out <- subject(x, 14) %>% summary
print(out)
```

```
ID: 14 
  visit   bedroom family  room living room
1     0  4.786592           NA     2.75000
2     1  3.401442     8.426549          NA
3     2 18.583635           NA    22.55069
```

```r
out <- subject(x, 44) %>% visit(0) %>% room("bedroom")
print(out)
```

```
ID: 44 
Visit: 0 
Room: bedroom 
```

```r
## Show a summary of the pollutant values
out <- subject(x, 44) %>% visit(0) %>% room("bedroom") %>% summary
print(out)
```

```
ID: 44 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    8.0    30.0    51.0    88.8    80.0   911.0 
```

```r
out <- subject(x, 44) %>% visit(1) %>% room("living room") %>% summary
print(out)
```

```
ID: 44 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   2.75   14.00   24.00   41.37   37.00 1607.00 
```


## R Package

Once you've completed writing your code, you should build an R package that includes the code and any documentation. You should make sure that your package passess all of the check in RStudio without any errors and warnings. 

Please name the package `Homework3<your last name>` and then upload it to the Courseplus dropbox. So for example, the name of my package would be `Homework3Peng`.















