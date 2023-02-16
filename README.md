
<!-- README.md is generated from README.Rmd. Please edit that file -->

# prepkit

<!-- badges: start -->
<!-- badges: end -->

Das Ziel von prepkit ist es die Datenaufbereitung zu erleichtern.

## Installation

Sie können die aktuelle Version von prepkit
über[GitHub](https://github.com/) installieren mit:

``` r
# install.packages("devtools")
devtools::install_github("aengels-git/prepkit")
```

## Beispiel: prep_pivot_table

Pivot Tables sind in Python’s Pandas Modul vorhanden. Prepkit bietet
eine benutzerfreundliche R-Adaption. Pivot Tables sind insbesondere
nützlich um Statistiken zu Ergebnisvariablen über mehrere Gruppen zu
vergleichen, da jede Gruppe eine eigene Spalte erhalten kann.

``` r
library(prepkit)
library(ggplot2)
prep_pivot_table(diamonds,
                 index = c(cut,clarity),# Variablen für die Aggregation über mehrere Zeilen
                 columns = color, # Gruppierungsvariablen für die das Outcome verglichen werden soll
                 outcomes = price, # Ergebnisvariablen
                 agg_funs = median) # default = mean
#> # A tibble: 40 × 9
#> # Groups:   cut [5]
#>    cut   clarity     D     E     F     G     H     I     J
#>    <ord> <ord>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 Fair  I1      5538. 2036  1570  1954  3340. 2396  5405 
#>  2 Fair  SI2     3473  3438. 3540  3598. 4129  4704  3302 
#>  3 Fair  SI1     3900  3508  3197  3145  3816  3308. 3604.
#>  4 Fair  VS2     4107  2508  2762  4838  3658  2794. 2854 
#>  5 Fair  VS1     2747  2071  3002  2396  3800  2732  3022 
#>  6 Fair  VVS2    1980  2079  2286  2167  2717  2322. 2998 
#>  7 Fair  VVS1    1792  2805  1040  2797  4115  4194  1691 
#>  8 Fair  IF      1440    NA  2502. 1488    NA    NA    NA 
#>  9 Good  I1      4014. 3484  2098  3127  3156. 3098  3356 
#> 10 Good  SI2     3540  3186. 3886  3852  3965  4953  4559 
#> # … with 30 more rows
```

## Beispiel: prep_freq_table

Die Funktion prep_freq_table bestimmt Häufigkeitstabellen, welche
anschließend leicht visualisiert werden können, da ein Tibble
zurückgegeben wird. Der Vorteil gegenüber anderen Funktionen ist, dass
Anteile (prop), bedingte Anteil (prop_bedingung) und absolute
Häufigkeiten (n) automatisch für jede Gruppierungsvariable bestimmt
werden. Es können beliebig viele Gruppierungsvariablen übergeben werden.

``` r
prep_freq_table(diamonds,cut,color)
#> # A tibble: 35 × 8
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
#> # … with 25 more rows
```

## Beispiel: prep_fct_recode

Die Funktion prep_fct_recode bietet eine alternative Möglichkeit
Faktorvariablen zu rekodieren:

``` r
prep_fct_recode(diamonds$cut,
                old_codes = c("Fair","Good","Very Good"),
                new_codes = c("Akzeptabel","Gut","Sehr gut"))[1:10]
#>  [1] Ideal      Premium    Gut        Premium    Gut        Sehr gut  
#>  [7] Sehr gut   Sehr gut   Akzeptabel Sehr gut  
#> Levels: Akzeptabel < Gut < Sehr gut < Premium < Ideal
```

# Beispiel date Funktionen

Die dt_function aus prepkit sind praktisch um Monatsanfang / ende des
Jahres + Monat oder den Monatsnamen zu bestimmen:

``` r
economics%>%select(date)%>%
  mutate(monats_anfang= dt_start_month(date),
         monats_ende = dt_end_month(date),
         monats_label = dt_month_recode(month(date),abbr=F),
         monat_jahr = dt_to_ym(date))
#> # A tibble: 574 × 5
#>    date       monats_anfang monats_ende monats_label monat_jahr
#>    <date>     <date>        <date>      <fct>        <fct>     
#>  1 1967-07-01 1967-07-01    1967-07-31  Juli         Jul 1967  
#>  2 1967-08-01 1967-08-01    1967-08-31  August       Aug 1967  
#>  3 1967-09-01 1967-09-01    1967-09-30  September    Sep 1967  
#>  4 1967-10-01 1967-10-01    1967-10-31  Oktober      Okt 1967  
#>  5 1967-11-01 1967-11-01    1967-11-30  November     Nov 1967  
#>  6 1967-12-01 1967-12-01    1967-12-31  Dezember     Dez 1967  
#>  7 1968-01-01 1968-01-01    1968-01-31  Januar       Jan 1968  
#>  8 1968-02-01 1968-02-01    1968-02-29  Februar      Feb 1968  
#>  9 1968-03-01 1968-03-01    1968-03-31  März         Mrz 1968  
#> 10 1968-04-01 1968-04-01    1968-04-30  April        Apr 1968  
#> # … with 564 more rows
```

# Beispiel str_replace_many

Die Funktion funktioniert wie str_replace aus stringr. Allerdings können
mehrere patterns / replacements übergeben werden

``` r
str_replace_many(diamonds$cut,patterns = c("Good","Very"),replacements = c("Gut","Sehr"))%>%unique()
#> [1] "Ideal"    "Premium"  "Gut"      "Sehr Gut" "Fair"
```
