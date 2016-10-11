---
title: "Homework 2 Solution"
output: 
  html_document: 
    keep_md: yes
permalink: /homework/homework2_sol.html
layout: default 
exclude: true
---

# Homework 2 Solution



## Homework 2: Functions


### Part 1

Write a function that computes the factorial of an integer greater than or equal to 0. The function should have the following skeleton.


```r
Factorial <- function(n) {
        if(n == 0) 
                return(1)
        else
                n * Factorial(n - 1)
}
```


```r
Factorial(5)
```

```
[1] 120
```


```r
Factorial2 <- function(n) {
        if(n == 0)
                return(1)
        vals <- seq(n, 1)
        Reduce("*", vals)
}

Factorial3 <- function(n) {
        if(n == 0)
                return(1)
        r <- 1
        for(val in seq_len(n)) {
                r <- r * val
        }
        r
}

Factorial4 <- function(n) {
        if(n == 0)
                return(1)
        vals <- seq(n, 1)
        prod(vals)
}
```

The `microbenchmark` package allows us to time the various implementations of the factorial function, including R's built in version.


```r
library(ggplot2)
library(microbenchmark)
m <- microbenchmark(Factorial(5), Factorial2(5), 
                    Factorial3(5), Factorial4(5),
                    factorial(5), times = 200L)
m
```

```
Unit: nanoseconds
          expr   min      lq      mean  median      uq    max neval
  Factorial(5)  3312  3741.5  4667.775  3947.0  4296.0  19172   200
 Factorial2(5) 12633 13661.5 16462.640 14273.5 15273.0 205220   200
 Factorial3(5)  1709  2021.5  2615.550  2219.0  2456.5  11012   200
 Factorial4(5)  5686  6415.5  9177.370  7051.5  7687.0 370353   200
  factorial(5)   380   456.5   768.820   564.5   655.5  13924   200
```

```r
autoplot(m)
```

![](unnamed-chunk-5-1.png)<!-- -->


### Part 2

The data for this part come from a study of indoor air pollution and respiratory disease conducted here at Johns Hopkins. A high-resolution air pollution monitor was placed in each home to collect continuous levels of particulate matter over the period of a few days (each measurement represents a 5-minute average). In addition, measurements were taken in different rooms of the house as well as on multiple visits. 


```r
library(readr)
library(dplyr)
library(ggplot2)
mie <- read_csv("data/MIE.csv", col_types = "iicdiDc")
```



```r
library(dplyr)
viz_mie <- function(data, idviz) {
        idset <- unique(data$id)
        if(!(idviz %in% idset))
                stop("id ", idviz, " is not in the dataset")
        p <- ggplot(data = filter(data, id == idviz)) +
                geom_line(aes(x = timepoint, y = value)) + 
                facet_grid(room ~ visit)
        print(p)
}
```


```r
viz_mie(mie, 14)
```

![](unnamed-chunk-8-1.png)<!-- -->

```r
viz_mie(mie, 54)
```

![](unnamed-chunk-8-2.png)<!-- -->



```r
viz_mie <- function(data, visitnum) {
        p <- ggplot(data = filter(data, visit == visitnum)) +
                geom_line(aes(x = timepoint, y = value)) + 
                facet_grid(id ~ room)
        print(p)
}
```

```r
viz_mie(mie, 0)
```

![](unnamed-chunk-10-1.png)<!-- -->

### Part 3

The `bootstrap()` function computes the 95% confidence interval for the median of a vector of numbers using the bootstrap procedure and the percentile method. 

The function takes as input `x` which should be a numeric vector. If it is not numeric, an attempt is made to coerce the vector to be numeric. Missing values in `x` are allowed and are ignored when computing the median.

The second argument is `N` which indicates the number of bootstrap iterations. The default is 1000, which is the minimum required for computing 95% confidence intervals. If you specify a value of `N` less than 1000, a warning is given.

Finally, the `seed` argument provides a value for the random number generator seed to ensure reproducible computations. This should be a numeric value. The default `NULL` just uses whatever the current value is (and hence is not reproducible).



```r
bootstrap <- function(x, N = 1000, seed = NULL) {
        if(!is.vector(x))
                stop("'x' should be a vector")
        if(!is.numeric(x))
                x <- as.numeric(x)
        if(N < 1000)
                warning("percentile intervals require N >= 1000")
        use <- !is.na(x)
        if(any(!use)) {
                message("removing missing values")
                x <- x[use]
        }
        set.seed(seed)
        b <- replicate(N, {
                x.new <- sample(x, replace = TRUE)
                median(x.new)
        })
        quantile(b, c(0.025, 0.975))
}
```


```r
source("data/median_testdata.R")
bootstrap(x1, seed = 10)
```

```
       2.5%       97.5% 
-0.38032184  0.04593217 
```

```r
bootstrap(x2, seed = 10)
```

```
    2.5%    97.5% 
13.42901 15.76853 
```

```r
bootstrap(x3, seed = 10)
```

```
removing missing values
```

```
     2.5%     97.5% 
-1.118927  1.234312 
```

```r
bootstrap(x4, seed = 10)
```

```
     2.5%     97.5% 
0.7916612 0.8636303 
```

```r
bootstrap(x5, seed = 10)
```

```
 2.5% 97.5% 
    5    15 
```

