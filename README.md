
<!-- README.md is generated from README.Rmd. Please edit that file -->

# prepkit

<!-- badges: start -->
<!-- badges: end -->

The goal of prepkit is to …

## Installation

You can install the development version of prepkit from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aengels-git/prepkit")
```

## Example

This is a basic example which shows you how to solve a recoding:

``` r
library(prepkit)
library(ggplot2)
#> Warning: package 'ggplot2' was built under R version 4.0.5
prep_fct_recode(diamonds$cut,c("Fair","Good"),c("Acceptable","Pretty good"))[1:10]
#> Loading required package: forcats
#> Loading required package: glue
#> Warning: package 'glue' was built under R version 4.0.5
#> Loading required package: rlang
#> Loading required package: purrr
#> 
#> Attaching package: 'purrr'
#> The following objects are masked from 'package:rlang':
#> 
#>     %@%, as_function, flatten, flatten_chr, flatten_dbl, flatten_int,
#>     flatten_lgl, flatten_raw, invoke, splice
#> Loading required package: stringr
#>  [1] Ideal       Premium     Pretty good Premium     Pretty good Very Good  
#>  [7] Very Good   Very Good   Acceptable  Very Good  
#> Levels: Acceptable < Pretty good < Very Good < Premium < Ideal
```

This is a basic example which shows you how to calculate a freq table:

``` r
prep_freq_table(diamonds,cut,color)
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> Loading required package: magrittr
#> Warning: package 'magrittr' was built under R version 4.0.5
#> 
#> Attaching package: 'magrittr'
#> The following object is masked from 'package:purrr':
#> 
#>     set_names
#> The following object is masked from 'package:rlang':
#> 
#>     set_names
#> Joining, by = "cut"Joining, by = "color"Joining, by = c("cut", "color", "n",
#> "n_cut", "n_color")Joining, by = c("cut", "color", "n", "n_cut", "n_color")
#> # A tibble: 35 x 8
#> # Groups:   cut [5]
#>    cut   color     n n_cut n_color prop_cut prop_color    prop
#>    <ord> <ord> <int> <int>   <int>    <dbl>      <dbl>   <dbl>
#>  1 Fair  D       163  1610    6775   0.101      0.0241 0.00302
#>  2 Fair  E       224  1610    9797   0.139      0.0229 0.00415
#>  3 Fair  F       312  1610    9542   0.194      0.0327 0.00578
#>  4 Fair  G       314  1610   11292   0.195      0.0278 0.00582
#>  5 Fair  H       303  1610    8304   0.188      0.0365 0.00562
#>  6 Fair  I       175  1610    5422   0.109      0.0323 0.00324
#>  7 Fair  J       119  1610    2808   0.0739     0.0424 0.00221
#>  8 Good  D       662  4906    6775   0.135      0.0977 0.0123 
#>  9 Good  E       933  4906    9797   0.190      0.0952 0.0173 
#> 10 Good  F       909  4906    9542   0.185      0.0953 0.0169 
#> # ... with 25 more rows
```

This is a basic example which shows you how to calculate mean tables:

``` r
prep_mean_table(diamonds,cut,outcomes=c("price"))
#> Loading required package: tidyverse
#> -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
#> v tibble 3.0.4     v readr  1.4.0
#> v tidyr  1.1.2
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x purrr::%@%()          masks rlang::%@%()
#> x purrr::as_function()  masks rlang::as_function()
#> x tidyr::extract()      masks magrittr::extract()
#> x dplyr::filter()       masks stats::filter()
#> x purrr::flatten()      masks rlang::flatten()
#> x purrr::flatten_chr()  masks rlang::flatten_chr()
#> x purrr::flatten_dbl()  masks rlang::flatten_dbl()
#> x purrr::flatten_int()  masks rlang::flatten_int()
#> x purrr::flatten_lgl()  masks rlang::flatten_lgl()
#> x purrr::flatten_raw()  masks rlang::flatten_raw()
#> x purrr::invoke()       masks rlang::invoke()
#> x dplyr::lag()          masks stats::lag()
#> x magrittr::set_names() masks purrr::set_names(), rlang::set_names()
#> x purrr::splice()       masks rlang::splice()
#> Loading required package: Hmisc
#> Loading required package: lattice
#> Loading required package: survival
#> Loading required package: Formula
#> 
#> Attaching package: 'Hmisc'
#> The following objects are masked from 'package:dplyr':
#> 
#>     src, summarize
#> The following objects are masked from 'package:base':
#> 
#>     format.pval, units
#> Joining, by = "cut"Joining, by = "cut"Joining, by = "cut"
#> # A tibble: 5 x 5
#>   cut       price sd_price n_cut     n
#>   <ord>     <dbl>    <dbl> <dbl> <dbl>
#> 1 Fair      4359.    3560.  1610  1610
#> 2 Good      3929.    3682.  4906  4906
#> 3 Very Good 3982.    3936. 12082 12082
#> 4 Premium   4584.    4349. 13791 13791
#> 5 Ideal     3458.    3808. 21551 21551
```
