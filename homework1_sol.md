---
title: "Homework 1 Solution"
output: 
  html_document: 
    keep_md: yes
permalink: /homework/homework1_sol.html
layout: default 
---




## Homework 1: Tidy Data

### Part 1

Load the `WorldPhones` dataset in the `datasets` package with



```r
library(datasets)
data(WorldPhones)
WorldPhones
```

```
     N.Amer Europe Asia S.Amer Oceania Africa Mid.Amer
1951  45939  21574 2876   1815    1646     89      555
1956  60423  29990 4708   2568    2366   1411      733
1957  64721  32510 5230   2695    2526   1546      773
1958  68484  35218 6662   2845    2691   1663      836
1959  71799  37598 6856   3000    2868   1769      911
1960  76036  40341 8220   3145    3054   1905     1008
1961  79831  43173 9053   3338    3224   2005     1076
```

This dataset gives the number of telephones in various regions of the world (in thousands). The regions are: North America, Europe, Asia, South America, Oceania, Africa, Central America and data are available for the years 1951, 1956, 1957, 1958, 1959, 1960, 1961.

Use the functions in `dplyr` and `tidyr` to produce a data frame that looks like this.


```r
library(dplyr)
library(tidyr)
tbl_df(WorldPhones) %>% 
        mutate(year = row.names(WorldPhones)) %>%
        gather(country, number, -year)
```

```
# A tibble: 49 × 3
    year country number
   <chr>   <chr>  <dbl>
1   1951  N.Amer  45939
2   1956  N.Amer  60423
3   1957  N.Amer  64721
4   1958  N.Amer  68484
5   1959  N.Amer  71799
6   1960  N.Amer  76036
7   1961  N.Amer  79831
8   1951  Europe  21574
9   1956  Europe  29990
10  1957  Europe  32510
# ... with 39 more rows
```

You may need to use functions outside these packages to obtain this result.

### Part 2


```r
library(readr)
spec <- read_csv("data/SPEC_2014.csv.bz2", progress = FALSE)
```

```
Parsed with column specification:
cols(
  .default = col_character(),
  Parameter.Code = col_integer(),
  POC = col_integer(),
  Latitude = col_double(),
  Longitude = col_double(),
  Date.Local = col_date(format = ""),
  Observation.Count = col_integer(),
  Observation.Percent = col_double(),
  Sample.Value = col_double(),
  X1st.Max.Value = col_double(),
  X1st.Max.Hour = col_integer(),
  Method.Code = col_integer(),
  Date.of.Last.Change = col_date(format = "")
)
```

```
See spec(...) for full column specifications.
```

```r
names(spec)
```

```
 [1] "State.Code"          "County.Code"         "Site.Num"           
 [4] "Parameter.Code"      "POC"                 "Latitude"           
 [7] "Longitude"           "Datum"               "Parameter.Name"     
[10] "Sample.Duration"     "Pollutant.Standard"  "Date.Local"         
[13] "Units.of.Measure"    "Event.Type"          "Observation.Count"  
[16] "Observation.Percent" "Sample.Value"        "X1st.Max.Value"     
[19] "X1st.Max.Hour"       "AQI"                 "Method.Code"        
[22] "State.Name"          "County.Name"         "City.Name"          
[25] "CBSA.Name"           "Date.of.Last.Change"
```

Use the functions in the `dplyr` package to answer the following questions:

1. What is average value of "Bromine PM2.5 LC" in the state of Wisconsin in this dataset?


```r
filter(spec, Parameter.Name == "Bromine PM2.5 LC" & State.Name == "Wisconsin") %>%
        summarize(avg = mean(Sample.Value))
```

```
# A tibble: 1 × 1
          avg
        <dbl>
1 0.003960482
```

2. Calculate the average of each chemical constituent across all states/monitors and all time points. Which constituent has the highest average level?


```r
group_by(spec, Parameter.Name) %>% 
        summarize(avg = mean(Sample.Value)) %>%
        arrange(desc(avg))                          
```

```
# A tibble: 86 × 2
                       Parameter.Name        avg
                                <chr>      <dbl>
1      OC CSN Unadjusted PM2.5 LC TOT 67.7838260
2                 EC CSN PM2.5 LC TOT  8.2065824
3           Total Carbon PM2.5 LC TOT  3.1132523
4  OC CSN_Rev Unadjusted PM2.5 LC TOT  2.3100559
5  OC CSN_Rev Unadjusted PM2.5 LC TOR  2.1695842
6                    Sulfate PM2.5 LC  1.1651597
7                     OC PM2.5 LC TOR  0.8511244
8              Total Nitrate PM2.5 LC  0.8224759
9     EC1 CSN_Rev Unadjusted PM2.5 LC  0.8091627
10              Ammonium Ion PM2.5 LC  0.7000858
# ... with 76 more rows
```

3. Which monitoring site has the highest levels of "Sulfate PM2.5 LC"? Indicate the state code, county code, and site number.


```r
filter(spec, Parameter.Name == "Sulfate PM2.5 LC") %>%
        group_by(State.Code, County.Code, Site.Num) %>%
        summarize(avg = mean(Sample.Value)) %>%
        arrange(desc(avg))
```

```
Source: local data frame [358 x 4]
Groups: State.Code, County.Code [313]

   State.Code County.Code Site.Num      avg
        <chr>       <chr>    <chr>    <dbl>
1          39         081     0017 3.182189
2          42         003     0064 3.055483
3          54         039     1005 2.938800
4          18         019     0006 2.738700
5          39         153     0023 2.706449
6          39         035     0060 2.640185
7          39         087     0012 2.638311
8          54         051     1002 2.619043
9          21         111     0067 2.549750
10         18         037     2001 2.516367
# ... with 348 more rows
```

4. What is the difference in the average levels of "EC PM2.5 LC TOR" between California and Arizona?


```r
filter(spec, State.Name %in% c("California", "Arizona") 
       & Parameter.Name == "EC PM2.5 LC TOR") %>%
       group_by(State.Name) %>%
        summarize(avg = mean(Sample.Value)) %>%
        spread(State.Name, avg) %>%
        mutate(diff = Arizona - California)
```

```
# A tibble: 1 × 3
    Arizona California        diff
      <dbl>      <dbl>       <dbl>
1 0.1791704  0.1977374 -0.01856696
```

5. What are the median levels of "OC PM2.5 LC TOR" and "EC PM2.5 LC TOR" in the western and eastern U.S.? Define western as any monitoring location that has a `Longitude` less than -100.


```r
filter(spec, Parameter.Name %in% c("OC PM2.5 LC TOR", "EC PM2.5 LC TOR")) %>%
       mutate(region = ifelse(Longitude < -100, "west", "east")) %>%
        group_by(Parameter.Name, region) %>%
        summarize(median = median(Sample.Value)) %>%
        spread(region, median)
```

```
Source: local data frame [2 x 3]
Groups: Parameter.Name [2]

   Parameter.Name  east  west
*           <chr> <dbl> <dbl>
1 EC PM2.5 LC TOR  0.17  0.06
2 OC PM2.5 LC TOR  0.88  0.43
```


### Part 3

Use the `readxl` package to read the file
[aqs_sites.xlsx](../data/aqs_sites.xlsx) into R (you may need to
install the package first). You may get some warnings when reading in the data but you can ignore these for now.


```r
spec <- read_csv("data/SPEC_2014.csv.bz2", progress = FALSE)
```

```
Parsed with column specification:
cols(
  .default = col_character(),
  Parameter.Code = col_integer(),
  POC = col_integer(),
  Latitude = col_double(),
  Longitude = col_double(),
  Date.Local = col_date(format = ""),
  Observation.Count = col_integer(),
  Observation.Percent = col_double(),
  Sample.Value = col_double(),
  X1st.Max.Value = col_double(),
  X1st.Max.Hour = col_integer(),
  Method.Code = col_integer(),
  Date.of.Last.Change = col_date(format = "")
)
```

```
See spec(...) for full column specifications.
```

```r
library(readxl)
sites <- read_excel("data/aqs_sites.xlsx")
names(sites) <-  gsub(" +", ".", names(sites))
names(sites)
```

```
 [1] "State.Code"            "County.Code"          
 [3] "Site.Number"           "Latitude"             
 [5] "Longitude"             "Datum"                
 [7] "Elevation"             "Land.Use"             
 [9] "Location.Setting"      "Site.Established.Date"
[11] "Site.Closed.Date"      "Met.Site.State.Code"  
[13] "Met.Site.County.Code"  "Met.Site.Site.Number" 
[15] "Met.Site.Type"         "Met.Site.Distance"    
[17] "Met.Site.Direction"    "GMT.Offset"           
[19] "Owning.Agency"         "Local.Site.Name"      
[21] "Address"               "Zip.Code"             
[23] "State.Name"            "County.Name"          
[25] "City.Name"             "CBSA.Name"            
[27] "Tribe.Name"            "Extraction.Date"      
```

Use the functions in the `dplyr` and `tidyr` packages to answer the following questions.

1. How many monitoring sites are labelled as both "RESIDENTIAL" for `Land Use` and "SUBURBAN" for `Location Setting`?


```r
filter(sites, Land.Use == "RESIDENTIAL" & Location.Setting == "SUBURBAN") %>%
        summarize(n = n())
```

```
# A tibble: 1 × 1
      n
  <int>
1  3527
```


```r
with(sites, table(Land.Use, Location.Setting))
```

```
                      Location.Setting
Land.Use               RURAL SUBURBAN UNKNOWN URBAN AND CENTER CITY
  AGRICULTURAL          2233       62       5                    10
  BLIGHTED AREAS           5        0       0                     3
  COMMERCIAL             353     1610      26                  3208
  DESERT                 140        2       1                     1
  FOREST                 620       15       1                     1
  INDUSTRIAL            1330     1207       3                  1008
  MILITARY RESERVATION     7        6       0                     1
  MOBILE                  20      110       0                   130
  RESIDENTIAL            753     3527      12                  1625
  UNKNOWN                145        0     896                     0
```

2. What are the median levels of "OC PM2.5 LC TOR" and "EC PM2.5 LC TOR" amongst monitoring sites that are labelled as both "RESIDENTIAL" and "SUBURBAN" in the eastern U.S., where eastern is defined as `Longitude` greater than or equal to -100?


```r
sites <- rename(sites, Site.Num = Site.Number) %>%
        select(State.Code, County.Code, Site.Num, Longitude, Land.Use, 
               Location.Setting)
spec <- mutate(spec, State.Code = as.numeric(State.Code),
               County.Code = as.numeric(County.Code),
               Site.Num = as.numeric(Site.Num)) %>%
        select(State.Code, County.Code, Site.Num, Parameter.Name, Sample.Value)
m <- left_join(spec, sites, by = c("State.Code", "County.Code", "Site.Num"))
str(m)
```

```
Classes 'tbl_df', 'tbl' and 'data.frame':	1519790 obs. of  8 variables:
 $ State.Code      : num  1 1 1 1 1 1 1 1 1 1 ...
 $ County.Code     : num  73 73 73 73 73 73 73 73 73 73 ...
 $ Site.Num        : num  23 23 23 23 23 23 23 23 23 23 ...
 $ Parameter.Name  : chr  "Antimony PM2.5 LC" "Antimony PM2.5 LC" "Antimony PM2.5 LC" "Antimony PM2.5 LC" ...
 $ Sample.Value    : num  0 0 0 0.012 0.008 0 0.006 0 0 0 ...
 $ Longitude       : num  -86.8 -86.8 -86.8 -86.8 -86.8 ...
 $ Land.Use        : chr  "COMMERCIAL" "COMMERCIAL" "COMMERCIAL" "COMMERCIAL" ...
 $ Location.Setting: chr  "URBAN AND CENTER CITY" "URBAN AND CENTER CITY" "URBAN AND CENTER CITY" "URBAN AND CENTER CITY" ...
```

```r
filter(m, Parameter.Name %in% c("OC PM2.5 LC TOR", "EC PM2.5 LC TOR")
       & Land.Use == "RESIDENTIAL" & Location.Setting == "SUBURBAN"
       & Longitude >= -100) %>%
        group_by(Parameter.Name) %>%
        summarize(median = median(Sample.Value))
```

```
# A tibble: 2 × 2
   Parameter.Name median
            <chr>  <dbl>
1 EC PM2.5 LC TOR   0.61
2 OC PM2.5 LC TOR   1.51
```
