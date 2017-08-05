# tidy Baseball Chapter 8
Chris Hamm  
`r format(Sys.Date())`  



## Chapter 8 - *Career trajectories*



```r
library("Lahman")
library("tidyverse"); options(dplyr.width = Inf)
```

```
## Loading tidyverse: ggplot2
## Loading tidyverse: tibble
## Loading tidyverse: tidyr
## Loading tidyverse: readr
## Loading tidyverse: purrr
## Loading tidyverse: dplyr
```

```
## Conflicts with tidy packages ----------------------------------------------
```

```
## filter(): dplyr, stats
## lag():    dplyr, stats
```

```r
set.seed(8761825)
devtools::session_info()
```

```
## Session info --------------------------------------------------------------
```

```
##  setting  value                       
##  version  R version 3.3.2 (2016-10-31)
##  system   x86_64, darwin13.4.0        
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  tz       America/New_York            
##  date     2017-01-08
```

```
## Packages ------------------------------------------------------------------
```

```
##  package    * version date       source        
##  assertthat   0.1     2013-12-06 CRAN (R 3.3.0)
##  backports    1.0.4   2016-10-24 CRAN (R 3.3.1)
##  colorspace   1.3-2   2016-12-14 CRAN (R 3.3.2)
##  DBI          0.5-1   2016-09-10 CRAN (R 3.3.0)
##  devtools     1.12.0  2016-06-24 CRAN (R 3.3.0)
##  digest       0.6.11  2017-01-03 CRAN (R 3.3.2)
##  dplyr      * 0.5.0   2016-06-24 CRAN (R 3.3.0)
##  evaluate     0.10    2016-10-11 CRAN (R 3.3.1)
##  ggplot2    * 2.2.1   2016-12-30 CRAN (R 3.3.2)
##  gtable       0.2.0   2016-02-26 CRAN (R 3.3.0)
##  htmltools    0.3.5   2016-03-21 CRAN (R 3.3.0)
##  knitr        1.15.1  2016-11-22 CRAN (R 3.3.2)
##  Lahman     * 5.0-0   2016-08-27 CRAN (R 3.3.0)
##  lazyeval     0.2.0   2016-06-12 CRAN (R 3.3.0)
##  magrittr     1.5     2014-11-22 CRAN (R 3.3.0)
##  memoise      1.0.0   2016-01-29 CRAN (R 3.3.0)
##  munsell      0.4.3   2016-02-13 CRAN (R 3.3.0)
##  plyr         1.8.4   2016-06-08 CRAN (R 3.3.0)
##  purrr      * 0.2.2   2016-06-18 CRAN (R 3.3.0)
##  R6           2.2.0   2016-10-05 CRAN (R 3.3.1)
##  Rcpp         0.12.8  2016-11-17 CRAN (R 3.3.2)
##  readr      * 1.0.0   2016-08-03 CRAN (R 3.3.0)
##  rmarkdown    1.3     2016-12-21 CRAN (R 3.3.2)
##  rprojroot    1.1     2016-10-29 CRAN (R 3.3.0)
##  scales       0.4.1   2016-11-09 CRAN (R 3.3.2)
##  stringi      1.1.2   2016-10-01 CRAN (R 3.3.1)
##  stringr      1.1.0   2016-08-19 CRAN (R 3.3.0)
##  tibble     * 1.2     2016-08-26 CRAN (R 3.3.0)
##  tidyr      * 0.6.0   2016-08-12 CRAN (R 3.3.1)
##  tidyverse  * 1.0.0   2016-09-09 CRAN (R 3.3.0)
##  withr        1.0.2   2016-06-20 CRAN (R 3.3.0)
##  yaml         2.1.14  2016-11-12 CRAN (R 3.3.2)
```

### Section 8.2 - *Mickey Mantel's Batting Trajectory*

```r
# The Batting and Master files are already loaded with the Lahman package. 
head(Batting) # using read.csv here rather than read_csv because it imports triples as X3B rather than 3B, which is not the best
```

```
##    playerID yearID stint teamID lgID  G  AB  R  H X2B X3B HR RBI SB CS BB
## 1 abercda01   1871     1    TRO   NA  1   4  0  0   0   0  0   0  0  0  0
## 2  addybo01   1871     1    RC1   NA 25 118 30 32   6   0  0  13  8  1  4
## 3 allisar01   1871     1    CL1   NA 29 137 28 40   4   5  0  19  3  1  2
## 4 allisdo01   1871     1    WS3   NA 27 133 28 44  10   2  2  27  1  1  0
## 5 ansonca01   1871     1    RC1   NA 25 120 29 39  11   3  0  16  6  2  2
## 6 armstbo01   1871     1    FW1   NA 12  49  9 11   2   1  0   5  0  1  0
##   SO IBB HBP SH SF GIDP
## 1  0  NA  NA NA NA   NA
## 2  0  NA  NA NA NA   NA
## 3  5  NA  NA NA NA   NA
## 4  2  NA  NA NA NA   NA
## 5  1  NA  NA NA NA   NA
## 6  1  NA  NA NA NA   NA
```

```r
# I don't know how to recode variables with dplyr so I will use recode from "car."
Batting$SF <- car::recode(Batting$SF, "NA = 0")
Batting$HBP <- car::recode(Batting$HBP, "NA = 0")
head(Batting)
```

```
##    playerID yearID stint teamID lgID  G  AB  R  H X2B X3B HR RBI SB CS BB
## 1 abercda01   1871     1    TRO   NA  1   4  0  0   0   0  0   0  0  0  0
## 2  addybo01   1871     1    RC1   NA 25 118 30 32   6   0  0  13  8  1  4
## 3 allisar01   1871     1    CL1   NA 29 137 28 40   4   5  0  19  3  1  2
## 4 allisdo01   1871     1    WS3   NA 27 133 28 44  10   2  2  27  1  1  0
## 5 ansonca01   1871     1    RC1   NA 25 120 29 39  11   3  0  16  6  2  2
## 6 armstbo01   1871     1    FW1   NA 12  49  9 11   2   1  0   5  0  1  0
##   SO IBB HBP SH SF GIDP
## 1  0  NA   0 NA  0   NA
## 2  0  NA   0 NA  0   NA
## 3  5  NA   0 NA  0   NA
## 4  2  NA   0 NA  0   NA
## 5  1  NA   0 NA  0   NA
## 6  1  NA   0 NA  0   NA
```

```r
dim(Batting)
```

```
## [1] 101332     22
```

```r
mantle.id <- Master %>% filter(nameFirst == "Mickey" & nameLast == "Mantle") %>% select(playerID)
mantle.id
```

```
##    playerID
## 1 mantlmi01
```

```r
get.birthyear <- function(player.id){
	playerline <- Master %>% 
	  filter(playerID == as.character(player.id))
	birthyear <- playerline$birthYear
	birthmonth <- playerline$birthMonth
	ifelse(birthmonth >= 7, birthyear + 1, birthyear)
}
get.birthyear(mantle.id)
```

```
## [1] 1932
```


#### Note that the book formula for OBP does not include HBP; if you exclude this you will get the incorrect result. The book inculdes hits in the denominator, which I have re-added as well.

```r
get.stats <- function(player.id){
	d <- Batting %>% filter(playerID == as.character(player.id))
	byear <- get.birthyear(as.character(player.id))
	d <- d %>% mutate(Age = yearID - byear, 
	             SLG = (((H - X2B - X3B - HR) + (2 * X2B) + (3 * X3B) + (4 * HR)) / AB), 
	             OBP = ((H + BB + HBP) / (AB + BB + SF + HBP)), 
	             OPS = SLG + OBP)
	return(d)
}
Mantle <- get.stats(mantle.id)
Mantle
```

```
##     playerID yearID stint teamID lgID   G  AB   R   H X2B X3B HR RBI SB CS
## 1  mantlmi01   1951     1    NYA   AL  96 341  61  91  11   5 13  65  8  7
## 2  mantlmi01   1952     1    NYA   AL 142 549  94 171  37   7 23  87  4  1
## 3  mantlmi01   1953     1    NYA   AL 127 461 105 136  24   3 21  92  8  4
## 4  mantlmi01   1954     1    NYA   AL 146 543 129 163  17  12 27 102  5  2
## 5  mantlmi01   1955     1    NYA   AL 147 517 121 158  25  11 37  99  8  1
## 6  mantlmi01   1956     1    NYA   AL 150 533 132 188  22   5 52 130 10  1
## 7  mantlmi01   1957     1    NYA   AL 144 474 121 173  28   6 34  94 16  3
## 8  mantlmi01   1958     1    NYA   AL 150 519 127 158  21   1 42  97 18  3
## 9  mantlmi01   1959     1    NYA   AL 144 541 104 154  23   4 31  75 21  3
## 10 mantlmi01   1960     1    NYA   AL 153 527 119 145  17   6 40  94 14  3
## 11 mantlmi01   1961     1    NYA   AL 153 514 132 163  16   6 54 128 12  1
## 12 mantlmi01   1962     1    NYA   AL 123 377  96 121  15   1 30  89  9  0
## 13 mantlmi01   1963     1    NYA   AL  65 172  40  54   8   0 15  35  2  1
## 14 mantlmi01   1964     1    NYA   AL 143 465  92 141  25   2 35 111  6  3
## 15 mantlmi01   1965     1    NYA   AL 122 361  44  92  12   1 19  46  4  1
## 16 mantlmi01   1966     1    NYA   AL 108 333  40  96  12   1 23  56  1  1
## 17 mantlmi01   1967     1    NYA   AL 144 440  63 108  17   0 22  55  1  1
## 18 mantlmi01   1968     1    NYA   AL 144 435  57 103  14   1 18  54  6  2
##     BB  SO IBB HBP SH SF GIDP Age       SLG       OBP       OPS
## 1   43  74  NA   0  2  0    3  19 0.4428152 0.3489583 0.7917736
## 2   75 111  NA   0  2  0    5  20 0.5300546 0.3942308 0.9242854
## 3   79  90  NA   0  0  0    2  21 0.4967462 0.3981481 0.8948944
## 4  102 107  NA   0  2  4    3  22 0.5248619 0.4083205 0.9331824
## 5  113  97   6   3  2  3    4  23 0.6112186 0.4308176 1.0420362
## 6  112  99   6   2  1  4    4  24 0.7054409 0.4639017 1.1693426
## 7  146  75  23   0  0  3    5  25 0.6645570 0.5120385 1.1765955
## 8  129 120  13   2  2  2   11  26 0.5915222 0.4432515 1.0347737
## 9   93 126   6   2  1  2    7  27 0.5138632 0.3902821 0.9041453
## 10 111 125   6   1  0  5   11  28 0.5578748 0.3990683 0.9569431
## 11 126 112   9   0  1  5    2  29 0.6867704 0.4480620 1.1348324
## 12 122  78   9   1  0  2    4  30 0.6047745 0.4860558 1.0908303
## 13  40  32   4   0  0  1    5  31 0.6220930 0.4413146 1.0634076
## 14  99 102  18   0  0  3    9  32 0.5913978 0.4232804 1.0146783
## 15  73  76   7   0  0  1   11  33 0.4515235 0.3793103 0.8308339
## 16  57  76   5   0  0  3    9  34 0.5375375 0.3893130 0.9268505
## 17 107 113   7   1  0  5    9  35 0.4340909 0.3905967 0.8246877
## 18 106  97   7   1  1  4    9  36 0.3977011 0.3846154 0.7823165
```

### Figure 8.1

```r
ggplot(Mantle, aes(x = Age, y = OPS)) + 
	theme_bw() + 
	geom_point(size = 3) +
	xlim(16, 39)
```

<div class="figure" style="text-align: center">
<img src="Chapter_8_files/figure-html/Fig_8.1-1.png" alt="Scatterplot of OPS against age for Mickey Mantle."  />
<p class="caption">Scatterplot of OPS against age for Mickey Mantle.</p>
</div>

Create a smooth curve of the quadratic:
$A + B(Age − 30) + C(Age − 30)^2$ where $A$, $B$, and $C$ are constants:

  1. The constant $A$ is predicted by the value of OPS when the player reaches 30 years of age. 
  1. The function reaches its highest value at
    $PEAK.AGE = 30 - \frac{B}{2C}$. This value is estiamted to be the player's peak batting performance. 
  1. The maximum value of the curve is: $Max = A - \frac{B^2}{4C}$. This is the estimate of the largest OPS of the player over his career. 
  1. The $C$ coefficient explains the curve of the quadratic function and usually takes a negative value. "Large" values represent stronger curves (rapid rise and delcline). We'll use the "lm" function to fit the quadratic curve formula: $OPS \sim I(Age - 30) + I((Age - 30)^2)$


```r
fit.model <- function(d){
	fit <- lm(OPS ~ I(Age - 30) + I((Age - 30)^2), data = d)
	b <- coef(fit)
	Age.max <- 30 - b[2] / b[3] / 2
	Max <- b[1] - b[2]^2 / b[3] / 4
	list(fit = fit, Age.max = Age.max, Max = Max)
}

F2 <- fit.model(Mantle)
F2
```

```
## $fit
## 
## Call:
## lm(formula = OPS ~ I(Age - 30) + I((Age - 30)^2), data = d)
## 
## Coefficients:
##     (Intercept)      I(Age - 30)  I((Age - 30)^2)  
##        1.043134        -0.022883        -0.003869  
## 
## 
## $Age.max
## I(Age - 30) 
##    27.04271 
## 
## $Max
## (Intercept) 
##     1.07697
```

```r
summary(F2$fit)
```

```
## 
## Call:
## lm(formula = OPS ~ I(Age - 30) + I((Age - 30)^2), data = d)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.17282 -0.04010  0.02203  0.04507  0.12819 
## 
## Coefficients:
##                   Estimate Std. Error t value Pr(>|t|)    
## (Intercept)      1.0431342  0.0279009  37.387 3.19e-16 ***
## I(Age - 30)     -0.0228830  0.0056381  -4.059 0.001029 ** 
## I((Age - 30)^2) -0.0038689  0.0008283  -4.671 0.000302 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.08421 on 15 degrees of freedom
## Multiple R-squared:  0.6018,	Adjusted R-squared:  0.5488 
## F-statistic: 11.34 on 2 and 15 DF,  p-value: 0.001001
```
This makes the model: 


```r
# I don't know how to add a function line in ggplot, so base R it is.
plot(x = Mantle$Age, y = Mantle$OPS, pch = 19, las = 1, , cex =1.5, ylab = "OPS", xlab = "Age", xlim = c(18, 37), ylim = c(0, 1.3))
lines(Mantle$Age, predict(F2$fit, Age = Mantle$Age), lwd = 3)
abline(v = F2$Age.max, lwd = 3, lty = 2, col = "grey")
abline(h = F2$Max, lwd = 3, lty = 2, col = "grey")
text(29.5, .72, "Peak.age" , cex = 2)
text(20, 1.175, "Max", cex = 2)
```

<div class="figure" style="text-align: center">
<img src="Chapter_8_files/figure-html/Fig_8.2-1.png" alt="Scatterplot of OPS against age for Mickey Mantle with a quadratic fit added. The location of the peak age and the maximum OPS fit are displayed."  />
<p class="caption">Scatterplot of OPS against age for Mickey Mantle with a quadratic fit added. The location of the peak age and the maximum OPS fit are displayed.</p>
</div>

### In honor of A-Rod retiring this season.

```r
Arod.id <- Master %>% filter(nameFirst == "Alex" & nameLast == "Rodriguez") %>% select(playerID)
get.birthyear(Arod.id)
```

```
## [1] 1976
```

```r
Arod <- get.stats(Arod.id) #only through 2015
A2 <- fit.model(Arod)
A2 # Arod peaked at 28 for OPS but stayed OK
```

```
## $fit
## 
## Call:
## lm(formula = OPS ~ I(Age - 30) + I((Age - 30)^2), data = d)
## 
## Coefficients:
##     (Intercept)      I(Age - 30)  I((Age - 30)^2)  
##        1.001657        -0.008514        -0.002974  
## 
## 
## $Age.max
## I(Age - 30) 
##    28.56881 
## 
## $Max
## (Intercept) 
##    1.007749
```

```r
# ggplot(Arod, aes(x = Age, y = OPS)) + theme_bw() + geom_point(size = 2) 
plot(x = Arod$Age, y = Arod$OPS, las = 1, pch = 19, cex =1.5, ylab = "OPS", xlab = "Age", xlim = c(17, 40), ylim = c(0, 1.1))
lines(Arod$Age, predict(A2$fit, Age = Arod$Age), lwd = 3, lty = 2)
```

<img src="Chapter_8_files/figure-html/A-Rod-1.png" style="display: block; margin: auto;" />

### Section 8.3 - *Comparing trajectories*

```r
head(Fielding)
```

```
##    playerID yearID stint teamID lgID POS  G GS InnOuts PO  A  E DP PB WP
## 1 abercda01   1871     1    TRO   NA  SS  1 NA      NA  1  3  2  0 NA NA
## 2  addybo01   1871     1    RC1   NA  2B 22 NA      NA 67 72 42  5 NA NA
## 3  addybo01   1871     1    RC1   NA  SS  3 NA      NA  8 14  7  0 NA NA
## 4 allisar01   1871     1    CL1   NA  2B  2 NA      NA  1  4  0  0 NA NA
## 5 allisar01   1871     1    CL1   NA  OF 29 NA      NA 51  3  7  1 NA NA
## 6 allisdo01   1871     1    WS3   NA   C 27 NA      NA 68 15 20  4  0 NA
##   SB CS ZR
## 1 NA NA NA
## 2 NA NA NA
## 3 NA NA NA
## 4 NA NA NA
## 5 NA NA NA
## 6 NA NA NA
```

```r
AB.totals <- Batting %>% group_by(playerID) %>% summarize(Career.AB = sum(AB, na.rm = TRUE))
head(AB.totals)
```

```
## # A tibble: 6 × 2
##    playerID Career.AB
##       <chr>     <int>
## 1 aardsda01         4
## 2 aaronha01     12364
## 3 aaronto01       944
## 4  aasedo01         5
## 5  abadan01        21
## 6  abadfe01         8
```

```r
Batting <- full_join(Batting, AB.totals, by = "playerID")
head(Batting)
```

```
##    playerID yearID stint teamID lgID  G  AB  R  H X2B X3B HR RBI SB CS BB
## 1 abercda01   1871     1    TRO   NA  1   4  0  0   0   0  0   0  0  0  0
## 2  addybo01   1871     1    RC1   NA 25 118 30 32   6   0  0  13  8  1  4
## 3 allisar01   1871     1    CL1   NA 29 137 28 40   4   5  0  19  3  1  2
## 4 allisdo01   1871     1    WS3   NA 27 133 28 44  10   2  2  27  1  1  0
## 5 ansonca01   1871     1    RC1   NA 25 120 29 39  11   3  0  16  6  2  2
## 6 armstbo01   1871     1    FW1   NA 12  49  9 11   2   1  0   5  0  1  0
##   SO IBB HBP SH SF GIDP Career.AB
## 1  0  NA   0 NA  0   NA         4
## 2  0  NA   0 NA  0   NA      1231
## 3  5  NA   0 NA  0   NA       740
## 4  2  NA   0 NA  0   NA      1407
## 5  1  NA   0 NA  0   NA     10277
## 6  1  NA   0 NA  0   NA        49
```

```r
Batting.2000 <- Batting %>% filter(Career.AB >= 2000)
head(Batting.2000)
```

```
##    playerID yearID stint teamID lgID  G  AB  R  H X2B X3B HR RBI SB CS BB
## 1 ansonca01   1871     1    RC1   NA 25 120 29 39  11   3  0  16  6  2  2
## 2 barnero01   1871     1    BS1   NA 31 157 66 63  10   9  0  34 11  6 13
## 3 careyto01   1871     1    FW1   NA 19  87 16 20   2   0  0  10  5  0  2
## 4 cuthbne01   1871     1    PH1   NA 28 150 47 37   7   5  3  30 16  2 10
## 5 eggleda01   1871     1    NY2   NA 33 147 37 47   7   3  0  18 14  3  4
## 6 fergubo01   1871     1    NY2   NA 33 158 30 38   6   1  0  25  4  4  3
##   SO IBB HBP SH SF GIDP Career.AB
## 1  1  NA   0 NA  0   NA     10277
## 2  1  NA   0 NA  0   NA      2392
## 3  1  NA   0 NA  0   NA      2394
## 4  2  NA   0 NA  0   NA      2113
## 5  3  NA   0 NA  0   NA      2546
## 6  2  NA   0 NA  0   NA      3468
```

```r
dim(Batting.2000)
```

```
## [1] 31751    23
```

```r
find.position <- function(p){
	positions <- c("OF", "1B", "2B", "SS", "3B", "C", "P", "DH")
	d <- subset(Fielding, playerID == p)
	count.games <- function(po)
		sum(subset(d, POS == po)$G)
	FLD <- sapply(positions, count.games)
	positions[FLD == max(FLD)][1]
}


PLAYER <- as.character(unique(Batting.2000$playerID))
POSITIONS <- sapply(PLAYER, find.position)
length(POSITIONS)
```

```
## [1] 2375
```

```r
Fielding.2000 <- data.frame(playerID = names(POSITIONS), POS = POSITIONS)
head(Fielding.2000)
```

```
##            playerID POS
## ansonca01 ansonca01  1B
## barnero01 barnero01  2B
## careyto01 careyto01  SS
## cuthbne01 cuthbne01  OF
## eggleda01 eggleda01  OF
## fergubo01 fergubo01  3B
```

```r
Batting.2000 <- left_join(Batting.2000, Fielding.2000, by = "playerID") # Becuase there are duplicate column names they get suffixes. The only way I know how to remove these is clunky.
```

```
## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
## factor and character vector, coercing into character vector
```

```r
# Batting.2000 <- merge(Batting.2000, Fielding.2000)
head(Batting.2000)
```

```
##    playerID yearID stint teamID lgID  G  AB  R  H X2B X3B HR RBI SB CS BB
## 1 ansonca01   1871     1    RC1   NA 25 120 29 39  11   3  0  16  6  2  2
## 2 barnero01   1871     1    BS1   NA 31 157 66 63  10   9  0  34 11  6 13
## 3 careyto01   1871     1    FW1   NA 19  87 16 20   2   0  0  10  5  0  2
## 4 cuthbne01   1871     1    PH1   NA 28 150 47 37   7   5  3  30 16  2 10
## 5 eggleda01   1871     1    NY2   NA 33 147 37 47   7   3  0  18 14  3  4
## 6 fergubo01   1871     1    NY2   NA 33 158 30 38   6   1  0  25  4  4  3
##   SO IBB HBP SH SF GIDP Career.AB POS
## 1  1  NA   0 NA  0   NA     10277  1B
## 2  1  NA   0 NA  0   NA      2392  2B
## 3  1  NA   0 NA  0   NA      2394  SS
## 4  2  NA   0 NA  0   NA      2113  OF
## 5  3  NA   0 NA  0   NA      2546  OF
## 6  2  NA   0 NA  0   NA      3468  3B
```

```r
dim(Batting.2000)
```

```
## [1] 31751    24
```

#### Calculating career statistics

```r
C.totals <- Batting.2000 %>% group_by(playerID) %>% summarize(
	C.G = sum(G, na.rm = TRUE), 
	C.AB = sum(AB, na.rm = TRUE), 
	C.R = sum(R, na.rm = TRUE), 
	C.H = sum(H, na.rm = TRUE), 
	C.2B = sum(X2B, na.rm = TRUE), 
	C.3B = sum(X3B, na.rm = TRUE), 
	C.HR = sum(HR, na.rm = TRUE), 
	C.RBI = sum(RBI, na.rm = TRUE), 
	C.BB = sum(BB, na.rm = TRUE), 
	C.SO = sum(SO, na.rm = TRUE), 
	C.SB = sum(SB, na.rm = TRUE)) %>% 
  mutate(C.AVG = (C.H / C.AB), 	C.SLG = (((C.H - C.2B - C.3B - C.HR) + (2 * C.2B) + (3 * C.3B) + (4 * C.HR)) / C.AB))
head(C.totals)
```

```
## # A tibble: 6 × 14
##    playerID   C.G  C.AB   C.R   C.H  C.2B  C.3B  C.HR C.RBI  C.BB  C.SO
##       <chr> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
## 1 aaronha01  3298 12364  2174  3771   624    98   755  2297  1402  1383
## 2 abbated01   855  3044   355   772    99    43    11   324   289    16
## 3 abbotku01   702  2044   273   523   109    23    62   242   133   571
## 4 abreubo01  2425  8480  1453  2470   574    59   288  1363  1476  1840
## 5 ackledu01   607  2064   255   503    94    18    46   212   186   410
## 6 adairje01  1165  4019   378  1022   163    19    57   366   208   499
##    C.SB     C.AVG     C.SLG
##   <int>     <dbl>     <dbl>
## 1   240 0.3049984 0.5545131
## 2   142 0.2536137 0.3252300
## 3    22 0.2558708 0.4227006
## 4   400 0.2912736 0.4747642
## 5    31 0.2437016 0.3735465
## 6    29 0.2542921 0.3468525
```

```r
C.totals <- inner_join(C.totals, Fielding.2000, by = "playerID")
```

```
## Warning in inner_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
## character vector and factor, coercing into character vector
```

```r
head(C.totals) 
```

```
## # A tibble: 6 × 15
##    playerID   C.G  C.AB   C.R   C.H  C.2B  C.3B  C.HR C.RBI  C.BB  C.SO
##       <chr> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
## 1 aaronha01  3298 12364  2174  3771   624    98   755  2297  1402  1383
## 2 abbated01   855  3044   355   772    99    43    11   324   289    16
## 3 abbotku01   702  2044   273   523   109    23    62   242   133   571
## 4 abreubo01  2425  8480  1453  2470   574    59   288  1363  1476  1840
## 5 ackledu01   607  2064   255   503    94    18    46   212   186   410
## 6 adairje01  1165  4019   378  1022   163    19    57   366   208   499
##    C.SB     C.AVG     C.SLG    POS
##   <int>     <dbl>     <dbl> <fctr>
## 1   240 0.3049984 0.5545131     OF
## 2   142 0.2536137 0.3252300     2B
## 3    22 0.2558708 0.4227006     SS
## 4   400 0.2912736 0.4747642     OF
## 5    31 0.2437016 0.3735465     2B
## 6    29 0.2542921 0.3468525     2B
```

```r
C.totals$Value.POS <- with(C.totals,
	ifelse(POS == "C", 240,
	ifelse(POS == "SS", 168,
	ifelse(POS == "2B", 132,
	ifelse(POS == "3B", 84,
	ifelse(POS == "OF", 48,
	ifelse(POS == "1B", 12, 0)))))))
head(C.totals)
```

```
## # A tibble: 6 × 16
##    playerID   C.G  C.AB   C.R   C.H  C.2B  C.3B  C.HR C.RBI  C.BB  C.SO
##       <chr> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
## 1 aaronha01  3298 12364  2174  3771   624    98   755  2297  1402  1383
## 2 abbated01   855  3044   355   772    99    43    11   324   289    16
## 3 abbotku01   702  2044   273   523   109    23    62   242   133   571
## 4 abreubo01  2425  8480  1453  2470   574    59   288  1363  1476  1840
## 5 ackledu01   607  2064   255   503    94    18    46   212   186   410
## 6 adairje01  1165  4019   378  1022   163    19    57   366   208   499
##    C.SB     C.AVG     C.SLG    POS Value.POS
##   <int>     <dbl>     <dbl> <fctr>     <dbl>
## 1   240 0.3049984 0.5545131     OF        48
## 2   142 0.2536137 0.3252300     2B       132
## 3    22 0.2558708 0.4227006     SS       168
## 4   400 0.2912736 0.4747642     OF        48
## 5    31 0.2437016 0.3735465     2B       132
## 6    29 0.2542921 0.3468525     2B       132
```

#### Computing similarity scores

```r
similar <- function(p, number){
	P <- subset(C.totals, playerID == p)
	C.totals$SS <- with(C.totals,
	1000 -
	floor(abs(C.G - P$C.G) / 20) -
	floor(abs(C.AB - P$C.AB) / 75) -
	floor(abs(C.R - P$C.R) / 10) -
	floor(abs(C.H - P$C.H) / 15) -
	floor(abs(C.2B - P$C.2B) / 5) -
	floor(abs(C.3B - P$C.3B) / 4) -
	floor(abs(C.HR - P$C.HR) / 2) -
	floor(abs(C.RBI - P$C.RBI) / 10) -
	floor(abs(C.BB - P$C.BB) / 25) -
	floor(abs(C.SO - P$C.SO) / 150) -
	floor(abs(C.SB - P$C.SB) / 20) -
	floor(abs(C.AVG - P$C.AVG) / 0.001) -
	floor(abs(C.SLG - P$C.SLG) / 0.002) -
	abs(Value.POS - P$Value.POS))
C.totals <- C.totals[order(C.totals$SS, decreasing = TRUE), ]
C.totals[1:number, ]
}
similar(as.character(mantle.id), 6) # This is nice and all but I bet that hierarchical cluster analysis could do a great job at this. 
```

```
## # A tibble: 6 × 17
##    playerID   C.G  C.AB   C.R   C.H  C.2B  C.3B  C.HR C.RBI  C.BB  C.SO
##       <chr> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
## 1 mantlmi01  2401  8102  1677  2415   344    72   536  1509  1733  1710
## 2 thomafr04  2322  8199  1494  2468   495    12   521  1704  1667  1397
## 3 matheed01  2391  8537  1509  2315   354    72   512  1453  1444  1487
## 4 schmimi01  2404  8352  1506  2234   408    59   548  1595  1507  1883
## 5 sheffga01  2576  9217  1636  2689   467    27   509  1676  1475  1171
## 6  sosasa01  2354  8813  1475  2408   379    45   609  1667   929  2306
##    C.SB     C.AVG     C.SLG    POS Value.POS    SS
##   <int>     <dbl>     <dbl> <fctr>     <dbl> <dbl>
## 1   153 0.2980745 0.5567761     OF        48  1000
## 2    32 0.3010123 0.5549457     1B        12   856
## 3    68 0.2711725 0.5094295     3B        84   853
## 4   174 0.2674808 0.5272989     3B        84   848
## 5   253 0.2917435 0.5139416     OF        48   847
## 6   234 0.2732327 0.5337569     OF        48   831
```

#### Defining age, OBP, SLG, and OPS variables

```r
collapse.stint <- function(d){
	d %>% group_by(playerID, yearID) %>% summarize(G = sum(G), AB = sum(AB), R = sum(R), H = sum(H), X2B = sum(X2B), X3B = sum(X3B), HR = sum(HR), RBI = sum(RBI), SB = sum(SB), CS = sum(CS), BB = sum(BB), SH = sum(SH), SF = sum(SF), HBP = sum(HBP), SLG = (((H - X2B - X3B - HR) + (2 * X2B) + (3 * X3B) + 4 * HR) / AB), OBP = ((H + BB + HBP) / (AB + BB + HBP + SF)), OPS = SLG + OBP, Career.AB = Career.AB[1], POS = POS[1]) # This is the correct OBP formula. Earlier it is incorrect.
} 
Batting.2000a <- Batting.2000 %>%
  group_by(playerID, yearID) %>%
  collapse.stint
head(Batting.2000a)
```

```
## Source: local data frame [6 x 21]
## Groups: playerID [1]
## 
##    playerID yearID     G    AB     R     H   X2B   X3B    HR   RBI    SB
##       <chr>  <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
## 1 aaronha01   1954   122   468    58   131    27     6    13    69     2
## 2 aaronha01   1955   153   602   105   189    37     9    27   106     3
## 3 aaronha01   1956   153   609   106   200    34    14    26    92     2
## 4 aaronha01   1957   151   615   118   198    27     6    44   132     1
## 5 aaronha01   1958   153   601   109   196    34     4    30    95     4
## 6 aaronha01   1959   154   629   116   223    46     7    39   123     8
##      CS    BB    SH    SF   HBP       SLG       OBP       OPS Career.AB
##   <int> <int> <int> <dbl> <dbl>     <dbl>     <dbl>     <dbl>     <int>
## 1     2    28     6     4     3 0.4465812 0.3220676 0.7686488     12364
## 2     1    49     7     4     3 0.5398671 0.3662614 0.9061285     12364
## 3     4    37     5     7     2 0.5582923 0.3648855 0.9231778     12364
## 4     1    57     0     3     0 0.6000000 0.3777778 0.9777778     12364
## 5     1    59     0     3     1 0.5457571 0.3855422 0.9312992     12364
## 6     0    51     0     9     4 0.6359300 0.4011544 1.0370844     12364
##      POS
##   <fctr>
## 1     OF
## 2     OF
## 3     OF
## 4     OF
## 5     OF
## 6     OF
```

```r
dim(Batting.2000a)
```

```
## [1] 29422    21
```

```r
player.list <- as.character(unique(Batting.2000$playerID))
birthyears <- sapply(player.list, get.birthyear)
Batting.2000a <- merge(Batting.2000a, data.frame(playerID = player.list, Birthyear = birthyears))
Batting.2000a$Age <- with(Batting.2000a, yearID - Birthyear)
Batting.2000a <- Batting.2000a[complete.cases(Batting.2000a$Age), ]
head(Batting.2000a)
```

```
##    playerID yearID   G  AB   R   H X2B X3B HR RBI SB CS BB SH SF HBP
## 1 aaronha01   1954 122 468  58 131  27   6 13  69  2  2 28  6  4   3
## 2 aaronha01   1955 153 602 105 189  37   9 27 106  3  1 49  7  4   3
## 3 aaronha01   1956 153 609 106 200  34  14 26  92  2  4 37  5  7   2
## 4 aaronha01   1957 151 615 118 198  27   6 44 132  1  1 57  0  3   0
## 5 aaronha01   1958 153 601 109 196  34   4 30  95  4  1 59  0  3   1
## 6 aaronha01   1959 154 629 116 223  46   7 39 123  8  0 51  0  9   4
##         SLG       OBP       OPS Career.AB POS Birthyear Age
## 1 0.4465812 0.3220676 0.7686488     12364  OF      1934  20
## 2 0.5398671 0.3662614 0.9061285     12364  OF      1934  21
## 3 0.5582923 0.3648855 0.9231778     12364  OF      1934  22
## 4 0.6000000 0.3777778 0.9777778     12364  OF      1934  23
## 5 0.5457571 0.3855422 0.9312992     12364  OF      1934  24
## 6 0.6359300 0.4011544 1.0370844     12364  OF      1934  25
```

#### Fitting and plotting trajectories

```r
fit.trajectory <- function(d){
  fit <- lm(OPS ~ I(Age - 30) + I((Age - 30)^2), data = d)
  data.frame(Age = d$Age, Fit = predict(fit, Age = d$Age))
}

plot.trajectories <- function(first, last, n.similar, ncol){
  
get.name <- function(playerid){
  d1 <- subset(Master, playerID == playerid)
  with(d1, paste(nameFirst, nameLast))
}

player.id <- subset(Master, nameFirst == first & nameLast == last)$playerID

player.id <- as.character(player.id)

player.list <- as.character(similar(player.id, n.similar)$playerID)

Batting.new <- subset(Batting.2000a, playerID %in% player.list)

F2 <- Batting.new %>%
  group_by(playerID) %>%
  fit.trajectory # note here the book calls for a function "plot.traj"
F2a <- merge(F2, data.frame(playerID = player.list, Name = sapply(as.character(player.list), get.name)))
print(ggplot(F2a, aes(x = Age, y = Fit)) +
  theme_bw() + 
  geom_line(size = 1.5) +
  facet_wrap(~ Name, ncol = ncol)) 
return(Batting.new)
}

plot.trajectories("Mickey", "Mantle", n.similar = 6, ncol = 2)
```

<img src="Chapter_8_files/figure-html/Sec_8.3.5-1.png" style="display: block; margin: auto;" />

```
##        playerID yearID   G  AB   R   H X2B X3B HR RBI SB CS  BB SH SF HBP
## 16504 mantlmi01   1951  96 341  61  91  11   5 13  65  8  7  43  2  0   0
## 16505 mantlmi01   1952 142 549  94 171  37   7 23  87  4  1  75  2  0   0
## 16506 mantlmi01   1953 127 461 105 136  24   3 21  92  8  4  79  0  0   0
## 16507 mantlmi01   1954 146 543 129 163  17  12 27 102  5  2 102  2  4   0
## 16508 mantlmi01   1955 147 517 121 158  25  11 37  99  8  1 113  2  3   3
## 16509 mantlmi01   1956 150 533 132 188  22   5 52 130 10  1 112  1  4   2
## 16510 mantlmi01   1957 144 474 121 173  28   6 34  94 16  3 146  0  3   0
## 16511 mantlmi01   1958 150 519 127 158  21   1 42  97 18  3 129  2  2   2
## 16512 mantlmi01   1959 144 541 104 154  23   4 31  75 21  3  93  1  2   2
## 16513 mantlmi01   1960 153 527 119 145  17   6 40  94 14  3 111  0  5   1
## 16514 mantlmi01   1961 153 514 132 163  16   6 54 128 12  1 126  1  5   0
## 16515 mantlmi01   1962 123 377  96 121  15   1 30  89  9  0 122  0  2   1
## 16516 mantlmi01   1963  65 172  40  54   8   0 15  35  2  1  40  0  1   0
## 16517 mantlmi01   1964 143 465  92 141  25   2 35 111  6  3  99  0  3   0
## 16518 mantlmi01   1965 122 361  44  92  12   1 19  46  4  1  73  0  1   0
## 16519 mantlmi01   1966 108 333  40  96  12   1 23  56  1  1  57  0  3   0
## 16520 mantlmi01   1967 144 440  63 108  17   0 22  55  1  1 107  0  5   1
## 16521 mantlmi01   1968 144 435  57 103  14   1 18  54  6  2 106  1  4   1
## 16842 matheed01   1952 145 528  80 128  23   5 25  58  6  4  59  5  0   1
## 16843 matheed01   1953 157 579 110 175  31   8 47 135  1  3  99  1  0   2
## 16844 matheed01   1954 138 476  96 138  21   4 40 103 10  3 113  3  7   2
## 16845 matheed01   1955 141 499 108 144  23   5 41 101  3  4 109  1  6   1
## 16846 matheed01   1956 151 552 103 150  21   2 37  95  6  0  91  3  4   1
## 16847 matheed01   1957 148 572 109 167  28   9 32  94  3  1  90  2  2   0
## 16848 matheed01   1958 149 546  97 137  18   1 31  77  5  0  85  8  8   2
## 16849 matheed01   1959 148 594 118 182  16   8 46 114  2  1  80  3  2   3
## 16850 matheed01   1960 153 548 108 152  19   7 39 124  7  3 111  4  6   2
## 16851 matheed01   1961 152 572 103 175  23   6 32  91 12  7  93  1  4   2
## 16852 matheed01   1962 152 536 106 142  25   6 29  90  4  2 101  0  4   2
## 16853 matheed01   1963 158 547  82 144  27   4 23  84  3  4 124  0  3   1
## 16854 matheed01   1964 141 502  83 117  19   1 23  74  2  2  85  0  2   1
## 16855 matheed01   1965 156 546  77 137  23   0 32  95  1  0  73  1  3   3
## 16856 matheed01   1966 134 452  72 113  21   4 16  53  1  1  63  1  1   0
## 16857 matheed01   1967 137 436  53 103  16   2 16  57  2  4  63  3  6   3
## 16858 matheed01   1968  31  52   4  11   0   0  3   8  0  0   5  0  0   0
## 23479 schmimi01   1972  13  34   2   7   0   0  1   3  0  0   5  0  0   1
## 23480 schmimi01   1973 132 367  43  72  11   0 18  52  8  2  62  1  4   9
## 23481 schmimi01   1974 162 568 108 160  28   7 36 116 23 12 106  3  5   4
## 23482 schmimi01   1975 158 562  93 140  34   3 38  95 29 12 101  6  1   4
## 23483 schmimi01   1976 160 584 112 153  31   4 38 107 14  9 100  3  7  11
## 23484 schmimi01   1977 154 544 114 149  27  11 38 101 15  8 104  1  9   9
## 23485 schmimi01   1978 145 513  93 129  27   2 21  78 19  6  91  0  8   4
## 23486 schmimi01   1979 160 541 109 137  25   4 45 114  9  5 120  2  9   3
## 23487 schmimi01   1980 150 548 104 157  25   8 48 121 12  5  89  0 13   2
## 23488 schmimi01   1981 102 354  78 112  19   2 31  91 12  4  73  0  3   4
## 23489 schmimi01   1982 148 514 108 144  26   3 35  87 14  7 107  0  7   3
## 23490 schmimi01   1983 154 534 104 136  16   4 40 109  7  8 128  0  4   3
## 23491 schmimi01   1984 151 528  93 146  23   3 36 106  5  7  92  0  8   4
## 23492 schmimi01   1985 158 549  89 152  31   5 33  93  1  3  87  0  6   3
## 23493 schmimi01   1986 160 552  97 160  29   1 37 119  1  2  89  0  9   7
## 23494 schmimi01   1987 147 522  88 153  28   0 35 113  2  1  83  0  6   2
## 23495 schmimi01   1988 108 390  52  97  21   2 12  62  3  0  49  0  6   6
## 23496 schmimi01   1989  42 148  19  30   7   0  6  28  0  1  21  0  3   0
## 23974 sheffga01   1988  24  80  12  19   1   0  4  12  3  1   7  1  1   0
## 23975 sheffga01   1989  95 368  34  91  18   0  5  32 10  6  27  3  3   4
## 23976 sheffga01   1990 125 487  67 143  30   1 10  67 25 10  44  4  9   3
## 23977 sheffga01   1991  50 175  25  34  12   2  2  22  5  5  19  1  5   3
## 23978 sheffga01   1992 146 557  87 184  34   3 33 100  5  6  48  0  7   6
## 23979 sheffga01   1993 140 494  67 145  20   5 20  73 17  5  47  0  7   9
## 23980 sheffga01   1994  87 322  61  89  16   1 27  78 12  6  51  0  5   6
## 23981 sheffga01   1995  63 213  46  69   8   0 16  46 19  4  55  0  2   4
## 23982 sheffga01   1996 161 519 118 163  33   1 42 120 16  9 142  0  6  10
## 23983 sheffga01   1997 135 444  86 111  22   1 21  71 11  7 121  0  2  15
## 23984 sheffga01   1998 130 437  73 132  27   2 22  85 22  7  95  0  9   8
## 23985 sheffga01   1999 152 549 103 165  20   0 34 101 11  5 101  0  9   4
## 23986 sheffga01   2000 141 501 105 163  24   3 43 109  4  6 101  0  6   4
## 23987 sheffga01   2001 143 515  98 160  28   2 36 100 10  4  94  0  5   4
## 23988 sheffga01   2002 135 492  82 151  26   0 25  84 12  2  72  0  4  11
## 23989 sheffga01   2003 155 576 126 190  37   2 39 132 18  4  86  0  8   8
## 23990 sheffga01   2004 154 573 117 166  30   1 36 121  5  6  92  0  8  11
## 23991 sheffga01   2005 154 584 104 170  27   0 34 123 10  2  78  0  5   8
## 23992 sheffga01   2006  39 151  22  45   5   0  6  25  5  1  13  0  1   1
## 23993 sheffga01   2007 133 494 107 131  20   1 25  75 22  5  84  0  6   9
## 23994 sheffga01   2008 114 418  52  94  16   0 19  57  9  2  58  0  1   5
## 23995 sheffga01   2009 100 268  44  74  13   2 10  43  2  1  40  0  2   2
## 24724  sosasa01   1989  58 183  27  47   8   0  4  13  7  5  11  5  2   2
## 24725  sosasa01   1990 153 532  72 124  26  10 15  70 32 16  33  2  6   6
## 24726  sosasa01   1991 116 316  39  64  10   1 10  33 13  6  14  5  1   2
## 24727  sosasa01   1992  67 262  41  68   7   2  8  25 15  7  19  4  2   4
## 24728  sosasa01   1993 159 598  92 156  25   5 33  93 36 11  38  0  1   4
## 24729  sosasa01   1994 105 426  59 128  17   6 25  70 22 13  25  1  4   2
## 24730  sosasa01   1995 144 564  89 151  17   3 36 119 34  7  58  0  2   5
## 24731  sosasa01   1996 124 498  84 136  21   2 40 100 18  5  34  0  4   5
## 24732  sosasa01   1997 162 642  90 161  31   4 36 119 22 12  45  0  5   2
## 24733  sosasa01   1998 159 643 134 198  20   0 66 158 18  9  73  0  5   1
## 24734  sosasa01   1999 162 625 114 180  24   2 63 141  7  8  78  0  6   3
## 24735  sosasa01   2000 156 604 106 193  38   1 50 138  7  4  91  0  8   2
## 24736  sosasa01   2001 160 577 146 189  34   5 64 160  0  2 116  0 12   6
## 24737  sosasa01   2002 150 556 122 160  19   2 49 108  2  0 103  0  4   3
## 24738  sosasa01   2003 137 517  99 144  22   0 40 103  0  1  62  0  5   5
## 24739  sosasa01   2004 126 478  69 121  21   0 35  80  0  0  56  0  3   2
## 24740  sosasa01   2005 102 380  39  84  15   1 14  45  1  1  39  0  3   2
## 24741  sosasa01   2007 114 412  53 104  24   1 21  92  0  0  34  0  5   3
## 26150 thomafr04   1990  60 191  39  63  11   3  7  31  0  1  44  0  3   2
## 26151 thomafr04   1991 158 559 104 178  31   2 32 109  1  2 138  0  2   1
## 26152 thomafr04   1992 160 573 108 185  46   2 24 115  6  3 122  0 11   5
## 26153 thomafr04   1993 153 549 106 174  36   0 41 128  4  2 112  0 13   2
## 26154 thomafr04   1994 113 399 106 141  34   1 38 101  2  3 109  0  7   2
## 26155 thomafr04   1995 145 493 102 152  27   0 40 111  3  2 136  0 12   6
## 26156 thomafr04   1996 141 527 110 184  26   0 40 134  1  1 109  0  8   5
## 26157 thomafr04   1997 146 530 110 184  35   0 35 125  1  1 109  0  7   3
## 26158 thomafr04   1998 160 585 109 155  35   2 29 109  7  0 110  0 11   6
## 26159 thomafr04   1999 135 486  74 148  36   0 15  77  3  3  87  0  8   9
## 26160 thomafr04   2000 159 582 115 191  44   0 43 143  1  3 112  0  8   5
## 26161 thomafr04   2001  20  68   8  15   3   0  4  10  0  0  10  0  1   0
## 26162 thomafr04   2002 148 523  77 132  29   1 28  92  3  0  88  0 10   7
## 26163 thomafr04   2003 153 546  87 146  35   0 42 105  0  0 100  0  4  12
## 26164 thomafr04   2004  74 240  53  65  16   0 18  49  0  2  64  0  1   6
## 26165 thomafr04   2005  34 105  19  23   3   0 12  26  0  0  16  0  3   0
## 26166 thomafr04   2006 137 466  77 126  11   0 39 114  0  0  81  0  6   6
## 26167 thomafr04   2007 155 531  63 147  30   0 26  95  0  0  81  0  5   7
## 26168 thomafr04   2008  71 246  27  59   7   1  8  30  0  0  39  0  1   3
##             SLG       OBP       OPS Career.AB POS Birthyear Age
## 16504 0.4428152 0.3489583 0.7917736      8102  OF      1932  19
## 16505 0.5300546 0.3942308 0.9242854      8102  OF      1932  20
## 16506 0.4967462 0.3981481 0.8948944      8102  OF      1932  21
## 16507 0.5248619 0.4083205 0.9331824      8102  OF      1932  22
## 16508 0.6112186 0.4308176 1.0420362      8102  OF      1932  23
## 16509 0.7054409 0.4639017 1.1693426      8102  OF      1932  24
## 16510 0.6645570 0.5120385 1.1765955      8102  OF      1932  25
## 16511 0.5915222 0.4432515 1.0347737      8102  OF      1932  26
## 16512 0.5138632 0.3902821 0.9041453      8102  OF      1932  27
## 16513 0.5578748 0.3990683 0.9569431      8102  OF      1932  28
## 16514 0.6867704 0.4480620 1.1348324      8102  OF      1932  29
## 16515 0.6047745 0.4860558 1.0908303      8102  OF      1932  30
## 16516 0.6220930 0.4413146 1.0634076      8102  OF      1932  31
## 16517 0.5913978 0.4232804 1.0146783      8102  OF      1932  32
## 16518 0.4515235 0.3793103 0.8308339      8102  OF      1932  33
## 16519 0.5375375 0.3893130 0.9268505      8102  OF      1932  34
## 16520 0.4340909 0.3905967 0.8246877      8102  OF      1932  35
## 16521 0.3977011 0.3846154 0.7823165      8102  OF      1932  36
## 16842 0.4469697 0.3197279 0.7666976      8537  3B      1932  20
## 16843 0.6269430 0.4058824 1.0328254      8537  3B      1932  21
## 16844 0.6029412 0.4230769 1.0260181      8537  3B      1932  22
## 16845 0.6012024 0.4130081 1.0142105      8537  3B      1932  23
## 16846 0.5181159 0.3734568 0.8915727      8537  3B      1932  24
## 16847 0.5402098 0.3870482 0.9272580      8537  3B      1932  25
## 16848 0.4578755 0.3494540 0.8073294      8537  3B      1932  26
## 16849 0.5925926 0.3902798 0.9828724      8537  3B      1932  27
## 16850 0.5510949 0.3973013 0.9483962      8537  3B      1932  28
## 16851 0.5349650 0.4023845 0.9373495      8537  3B      1932  29
## 16852 0.4962687 0.3810264 0.8772951      8537  3B      1932  30
## 16853 0.4533821 0.3985185 0.8519006      8537  3B      1932  31
## 16854 0.4123506 0.3440678 0.7564184      8537  3B      1932  32
## 16855 0.4688645 0.3408000 0.8096645      8537  3B      1932  33
## 16856 0.4203540 0.3410853 0.7614393      8537  3B      1932  34
## 16857 0.3922018 0.3326772 0.7248790      8537  3B      1932  35
## 16858 0.3846154 0.2807018 0.6653171      8537  3B      1932  36
## 23479 0.2941176 0.3250000 0.6191176      8352  3B      1950  22
## 23480 0.3732970 0.3235294 0.6968264      8352  3B      1950  23
## 23481 0.5457746 0.3953148 0.9410894      8352  3B      1950  24
## 23482 0.5231317 0.3667665 0.8898981      8352  3B      1950  25
## 23483 0.5239726 0.3760684 0.9000410      8352  3B      1950  26
## 23484 0.5735294 0.3933934 0.9669228      8352  3B      1950  27
## 23485 0.4346979 0.3636364 0.7983342      8352  3B      1950  28
## 23486 0.5637708 0.3863299 0.9501007      8352  3B      1950  29
## 23487 0.6240876 0.3803681 1.0044557      8352  3B      1950  30
## 23488 0.6440678 0.4354839 1.0795517      8352  3B      1950  31
## 23489 0.5466926 0.4025357 0.9492283      8352  3B      1950  32
## 23490 0.5243446 0.3991031 0.9234477      8352  3B      1950  33
## 23491 0.5359848 0.3829114 0.9188962      8352  3B      1950  34
## 23492 0.5318761 0.3751938 0.9070699      8352  3B      1950  35
## 23493 0.5471014 0.3896499 0.9367514      8352  3B      1950  36
## 23494 0.5478927 0.3882545 0.9361472      8352  3B      1950  37
## 23495 0.4051282 0.3370288 0.7421570      8352  3B      1950  38
## 23496 0.3716216 0.2965116 0.6681332      8352  3B      1950  39
## 23974 0.4000000 0.2954545 0.6954545      9217  OF      1969  19
## 23975 0.3369565 0.3034826 0.6404391      9217  OF      1969  20
## 23976 0.4209446 0.3499079 0.7708525      9217  OF      1969  21
## 23977 0.3200000 0.2772277 0.5972277      9217  OF      1969  22
## 23978 0.5798923 0.3851133 0.9650055      9217  OF      1969  23
## 23979 0.4757085 0.3608618 0.8365703      9217  OF      1969  24
## 23980 0.5838509 0.3802083 0.9640593      9217  OF      1969  25
## 23981 0.5868545 0.4671533 1.0540077      9217  OF      1969  26
## 23982 0.6242775 0.4652880 1.0895655      9217  OF      1969  27
## 23983 0.4459459 0.4243986 0.8703446      9217  OF      1969  28
## 23984 0.5240275 0.4280510 0.9520785      9217  OF      1969  29
## 23985 0.5227687 0.4072398 0.9300085      9217  OF      1969  30
## 23986 0.6427146 0.4379085 1.0806231      9217  OF      1969  31
## 23987 0.5825243 0.4174757 1.0000000      9217  OF      1969  32
## 23988 0.5121951 0.4041451 0.9163402      9217  OF      1969  33
## 23989 0.6041667 0.4188791 1.0230457      9217  OF      1969  34
## 23990 0.5340314 0.3932749 0.9273063      9217  OF      1969  35
## 23991 0.5119863 0.3792593 0.8912456      9217  OF      1969  36
## 23992 0.4503311 0.3554217 0.8057528      9217  OF      1969  37
## 23993 0.4615385 0.3777403 0.8392788      9217  OF      1969  38
## 23994 0.3995215 0.3257261 0.7252477      9217  OF      1969  39
## 23995 0.4514925 0.3717949 0.8232874      9217  OF      1969  40
## 24724 0.3661202 0.3030303 0.6691505      8813  OF      1969  20
## 24725 0.4041353 0.2824957 0.6866310      8813  OF      1969  21
## 24726 0.3354430 0.2402402 0.5756833      8813  OF      1969  22
## 24727 0.3931298 0.3170732 0.7102029      8813  OF      1969  23
## 24728 0.4849498 0.3088924 0.7938422      8813  OF      1969  24
## 24729 0.5446009 0.3391685 0.8837694      8813  OF      1969  25
## 24730 0.5000000 0.3402226 0.8402226      8813  OF      1969  26
## 24731 0.5642570 0.3234750 0.8877321      8813  OF      1969  27
## 24732 0.4797508 0.2997118 0.7794626      8813  OF      1969  28
## 24733 0.6469673 0.3767313 1.0236986      8813  OF      1969  29
## 24734 0.6352000 0.3665730 1.0017730      8813  OF      1969  30
## 24735 0.6341060 0.4056738 1.0397797      8813  OF      1969  31
## 24736 0.7365685 0.4374121 1.1739806      8813  OF      1969  32
## 24737 0.5935252 0.3993994 0.9929246      8813  OF      1969  33
## 24738 0.5531915 0.3582343 0.9114258      8813  OF      1969  34
## 24739 0.5167364 0.3320965 0.8488329      8813  OF      1969  35
## 24740 0.3763158 0.2948113 0.6711271      8813  OF      1969  36
## 24741 0.4684466 0.3105727 0.7790193      8813  OF      1969  38
## 26150 0.5287958 0.4541667 0.9829625      8199  1B      1968  22
## 26151 0.5527728 0.4528571 1.0056300      8199  1B      1968  23
## 26152 0.5357766 0.4388186 0.9745952      8199  1B      1968  24
## 26153 0.6065574 0.4260355 1.0325929      8199  1B      1968  25
## 26154 0.7293233 0.4874275 1.2167508      8199  1B      1968  26
## 26155 0.6064909 0.4544049 1.0608958      8199  1B      1968  27
## 26156 0.6261860 0.4591680 1.0853539      8199  1B      1968  28
## 26157 0.6113208 0.4560863 1.0674070      8199  1B      1968  29
## 26158 0.4803419 0.3806180 0.8609599      8199  1B      1968  30
## 26159 0.4711934 0.4135593 0.8847527      8199  1B      1968  31
## 26160 0.6254296 0.4356436 1.0610731      8199  1B      1968  32
## 26161 0.4411765 0.3164557 0.7576322      8199  1B      1968  33
## 26162 0.4722753 0.3614650 0.8337403      8199  1B      1968  34
## 26163 0.5622711 0.3897281 0.9519992      8199  1B      1968  35
## 26164 0.5625000 0.4340836 0.9965836      8199  1B      1968  36
## 26165 0.5904762 0.3145161 0.9049923      8199  1B      1968  37
## 26166 0.5450644 0.3810376 0.9261019      8199  1B      1968  38
## 26167 0.4802260 0.3766026 0.8568286      8199  1B      1968  39
## 26168 0.3739837 0.3494810 0.7234647      8199  1B      1968  40
```

```r
plot.trajectories("Derek", "Jeter", n.similar = 9, ncol = 3)
```

<img src="Chapter_8_files/figure-html/Sec_8.3.5-2.png" style="display: block; margin: auto;" />

```
##        playerID yearID   G  AB   R   H X2B X3B HR RBI SB CS  BB SH SF HBP
## 296   alomaro01   1988 143 545  84 145  24   6  9  41 24  6  47 16  0   3
## 297   alomaro01   1989 158 623  82 184  27   1  7  56 42 17  53 17  8   1
## 298   alomaro01   1990 147 586  80 168  27   5  6  60 24  7  48  5  5   2
## 299   alomaro01   1991 161 637  88 188  41  11  9  69 53 11  57 16  5   4
## 300   alomaro01   1992 152 571 105 177  27   8  8  76 49  9  87  6  2   5
## 301   alomaro01   1993 153 589 109 192  35   6 17  93 55 15  80  4  5   5
## 302   alomaro01   1994 107 392  78 120  25   4  8  38 19  8  51  7  3   2
## 303   alomaro01   1995 130 517  71 155  24   7 13  66 30  3  47  6  7   0
## 304   alomaro01   1996 153 588 132 193  43   4 22  94 17  6  90  8 12   1
## 305   alomaro01   1997 112 412  64 137  23   2 14  60  9  3  40  7  7   3
## 306   alomaro01   1998 147 588  86 166  36   1 14  56 18  5  59  3  5   2
## 307   alomaro01   1999 159 563 138 182  40   3 24 120 37  6  99 12 13   7
## 308   alomaro01   2000 155 610 111 189  40   2 19  89 39  4  64 11  6   6
## 309   alomaro01   2001 157 575 113 193  34  12 20 100 30  6  80  9  9   4
## 310   alomaro01   2002 149 590  73 157  24   4 11  53 16  4  57  6  1   1
## 311   alomaro01   2003 140 516  76 133  28   2  5  39 12  2  59 12  8   3
## 312   alomaro01   2004  56 171  18  45   6   2  4  24  0  2  14  3  1   1
## 1993  biggicr01   1988  50 123  14  26   6   1  3   5  6  1   7  1  0   0
## 1994  biggicr01   1989 134 443  64 114  21   2 13  60 21  3  49  6  5   6
## 1995  biggicr01   1990 150 555  53 153  24   2  4  42 25 11  53  9  1   3
## 1996  biggicr01   1991 149 546  79 161  23   4  4  46 19  6  53  5  3   2
## 1997  biggicr01   1992 162 613  96 170  32   3  6  39 38 15  94  5  2   7
## 1998  biggicr01   1993 155 610  98 175  41   5 21  64 15 17  77  4  5  10
## 1999  biggicr01   1994 114 437  88 139  44   5  6  56 39  4  62  2  2   8
## 2000  biggicr01   1995 141 553 123 167  30   2 22  77 33  8  80 11  7  22
## 2001  biggicr01   1996 162 605 113 174  24   4 15  75 25  7  75  8  8  27
## 2002  biggicr01   1997 162 619 146 191  37   8 22  81 47 10  84  0  7  34
## 2003  biggicr01   1998 160 646 123 210  51   2 20  88 50  8  64  1  4  23
## 2004  biggicr01   1999 160 639 123 188  56   0 16  73 28 14  88  5  6  11
## 2005  biggicr01   2000 101 377  67 101  13   5  8  35 12  2  61  7  5  16
## 2006  biggicr01   2001 155 617 118 180  35   3 20  70  7  4  66  0  6  28
## 2007  biggicr01   2002 145 577  96 146  36   3 15  58 16  2  50  9  2  17
## 2008  biggicr01   2003 153 628 102 166  44   2 15  62  8  4  57  3  2  27
## 2009  biggicr01   2004 156 633 100 178  47   0 24  63  7  2  40  9  3  15
## 2010  biggicr01   2005 155 590  94 156  40   1 26  69 11  1  37  4  3  17
## 2011  biggicr01   2006 145 548  79 135  33   0 21  62  3  2  40  5  5   9
## 2012  biggicr01   2007 141 517  68 130  31   3 10  50  4  3  23  7  5   3
## 8725  francju01   1982  16  29   3   8   1   0  0   3  0  2   2  1  0   0
## 8726  francju01   1983 149 560  68 153  24   8  8  80 32 12  27  3  6   2
## 8727  francju01   1984 160 658  82 188  22   5  3  79 19 10  43  1 10   6
## 8728  francju01   1985 160 636  97 183  33   4  6  90 13  9  54  0  9   4
## 8729  francju01   1986 149 599  80 183  30   5 10  74 10  7  32  0  5   0
## 8730  francju01   1987 128 495  86 158  24   3  8  52 32  9  57  0  5   3
## 8731  francju01   1988 152 613  88 186  23   6 10  54 25 11  56  1  4   2
## 8732  francju01   1989 150 548  80 173  31   5 13  92 21  3  66  0  6   1
## 8733  francju01   1990 157 582  96 172  27   1 11  69 31 10  82  2  2   2
## 8734  francju01   1991 146 589 108 201  27   3 15  78 36  9  65  0  2   3
## 8735  francju01   1992  35 107  19  25   7   0  2   8  1  1  15  1  0   0
## 8736  francju01   1993 144 532  85 154  31   3 14  84  9  3  62  5  7   1
## 8737  francju01   1994 112 433  72 138  19   2 20  98  8  1  62  0  5   5
## 8738  francju01   1996 112 432  72 139  20   1 14  76  8  8  61  0  3   3
## 8739  francju01   1997 120 430  68 116  16   1  7  44 15  6  69  1  4   1
## 8740  francju01   1999   1   1   0   0   0   0  0   0  0  0   0  0  0   0
## 8741  francju01   2001  25  90  13  27   4   0  3  11  0  0  10  0  0   1
## 8742  francju01   2002 125 338  51  96  13   1  6  30  5  1  39  2  3   1
## 8743  francju01   2003 103 197  28  58  12   2  5  31  0  1  25  0  1   0
## 8744  francju01   2004 125 320  37  99  18   3  6  57  4  2  36  1  3   1
## 8745  francju01   2005 108 233  30  64  12   1  9  42  4  0  27  1  3   1
## 8746  francju01   2006  95 165  14  45  10   0  2  26  6  1  13  0  0   1
## 8747  francju01   2007  55  90   8  20   3   0  1  16  2  1  14  0  2   0
## 9368  gehrich01   1924   5  13   2   6   0   0  0   1  1  1   0  0  0   0
## 9369  gehrich01   1925   8  18   3   3   0   0  0   0  0  1   2  0  0   0
## 9370  gehrich01   1926 123 459  62 127  19  17  1  48  9  7  30 27  0   1
## 9371  gehrich01   1927 133 508 110 161  29  11  4  61 17  8  52  9  0   2
## 9372  gehrich01   1928 154 603 108 193  29  16  6  74 15  9  69 13  0   6
## 9373  gehrich01   1929 155 634 131 215  45  19 13 106 27  9  64 11  0   6
## 9374  gehrich01   1930 154 610 144 201  47  15 16  98 19 15  69 13  0   7
## 9375  gehrich01   1931 101 383  67 119  24   5  4  53 13  4  29  2  0   0
## 9376  gehrich01   1932 152 618 112 184  44  11 19 107  9  8  68  3  0   3
## 9377  gehrich01   1933 155 628 103 204  42   6 12 105  5  4  68  6  0   3
## 9378  gehrich01   1934 154 601 134 214  50   7 11 127 11  8  99  5  0   3
## 9379  gehrich01   1935 150 610 123 201  32   8 19 108 11  4  79 17  0   3
## 9380  gehrich01   1936 154 641 144 227  60  12 15 116  4  1  83  3  0   4
## 9381  gehrich01   1937 144 564 133 209  40   1 14  96 11  4  90  5  0   1
## 9382  gehrich01   1938 152 568 133 174  32   5 20 107 14  1 113  3  0   4
## 9383  gehrich01   1939 118 406  86 132  29   6 16  86  4  3  68 11  0   1
## 9384  gehrich01   1940 139 515 108 161  33   3 10  81 10  0 101 10  0   3
## 9385  gehrich01   1941 127 436  65  96  19   4  3  46  1  2  95  3  0   3
## 9386  gehrich01   1942  45  45   6  12   0   0  1   7  0  0   7  0  0   0
## 13241 jeterde01   1995  15  48   5  12   4   1  0   7  0  0   3  0  0   0
## 13242 jeterde01   1996 157 582 104 183  25   6 10  78 14  7  48  6  9   9
## 13243 jeterde01   1997 159 654 116 190  31   7 10  70 23 12  74  8  2  10
## 13244 jeterde01   1998 149 626 127 203  25   8 19  84 30  6  57  3  3   5
## 13245 jeterde01   1999 158 627 134 219  37   9 24 102 19  8  91  3  6  12
## 13246 jeterde01   2000 148 593 119 201  31   4 15  73 22  4  68  3  3  12
## 13247 jeterde01   2001 150 614 110 191  35   3 21  74 27  3  56  5  1  10
## 13248 jeterde01   2002 157 644 124 191  26   0 18  75 32  3  73  3  3   7
## 13249 jeterde01   2003 119 482  87 156  25   3 10  52 11  5  43  3  1  13
## 13250 jeterde01   2004 154 643 111 188  44   1 23  78 23  4  46 16  2  14
## 13251 jeterde01   2005 159 654 122 202  25   5 19  70 14  5  77  7  3  11
## 13252 jeterde01   2006 154 623 118 214  39   3 14  97 34  5  69  7  4  12
## 13253 jeterde01   2007 156 639 102 206  39   4 12  73 15  8  56  3  2  14
## 13254 jeterde01   2008 150 596  88 179  25   3 11  69 11  5  52  7  4   9
## 13255 jeterde01   2009 153 634 107 212  27   1 18  66 30  5  72  4  1   5
## 13256 jeterde01   2010 157 663 111 179  30   3 10  67 18  5  63  1  3   9
## 13257 jeterde01   2011 131 546  84 162  24   4  6  61 16  6  46  4  5   6
## 13258 jeterde01   2012 159 683  99 216  32   0 15  58  9  4  45  6  1   5
## 13259 jeterde01   2013  17  63   8  12   1   0  1   7  0  0   8  0  1   1
## 13260 jeterde01   2014 145 581  47 149  19   1  4  50 10  2  35  8  4   6
## 18447 molitpa01   1978 125 521  73 142  26   4  6  45 30 12  19  7  5   4
## 18448 molitpa01   1979 140 584  88 188  27  16  9  62 33 13  48  6  5   2
## 18449 molitpa01   1980 111 450  81 137  29   2  9  37 34  7  48  6  5   3
## 18450 molitpa01   1981  64 251  45  67  11   0  2  19 10  6  25  5  0   3
## 18451 molitpa01   1982 160 666 136 201  26   8 19  71 41  9  69 10  5   1
## 18452 molitpa01   1983 152 608  95 164  28   6 15  47 41  8  59  7  6   2
## 18453 molitpa01   1984  13  46   3  10   1   0  0   6  1  0   2  0  1   0
## 18454 molitpa01   1985 140 576  93 171  28   3 10  48 21  7  54  7  4   1
## 18455 molitpa01   1986 105 437  62 123  24   6  9  55 20  5  40  2  3   0
## 18456 molitpa01   1987 118 465 114 164  41   5 16  75 45 10  69  5  1   2
## 18457 molitpa01   1988 154 609 115 190  34   6 13  60 41 10  71  5  3   2
## 18458 molitpa01   1989 155 615  84 194  35   4 11  56 27 11  64  4  9   4
## 18459 molitpa01   1990 103 418  64 119  27   6 12  45 18  3  37  0  2   1
## 18460 molitpa01   1991 158 665 133 216  32  13 17  75 19  8  77  0  1   6
## 18461 molitpa01   1992 158 609  89 195  36   7 12  89 31  6  73  4 11   3
## 18462 molitpa01   1993 160 636 121 211  37   5 22 111 22  4  77  1  8   3
## 18463 molitpa01   1994 115 454  86 155  30   4 14  75 20  0  55  0  5   1
## 18464 molitpa01   1995 130 525  63 142  31   2 15  60 12  0  61  3  4   5
## 18465 molitpa01   1996 161 660  99 225  41   8  9 113 18  6  56  0  9   3
## 18466 molitpa01   1997 135 538  63 164  32   4 10  89 11  4  45  2 12   0
## 18467 molitpa01   1998 126 502  75 141  29   5  4  69  9  2  45  1 10   1
## 22270 ripkeca01   1981  23  39   1   5   0   0  0   0  0  0   1  0  0   0
## 22271 ripkeca01   1982 160 598  90 158  32   5 28  93  3  3  46  2  6   3
## 22272 ripkeca01   1983 162 663 121 211  47   2 27 102  0  4  58  0  5   0
## 22273 ripkeca01   1984 162 641 103 195  37   7 27  86  2  1  71  0  2   2
## 22274 ripkeca01   1985 161 642 116 181  32   5 26 110  2  3  67  0  8   1
## 22275 ripkeca01   1986 162 627  98 177  35   1 25  81  4  2  70  0  6   4
## 22276 ripkeca01   1987 162 624  97 157  28   3 27  98  3  5  81  0 11   1
## 22277 ripkeca01   1988 161 575  87 152  25   1 23  81  2  2 102  0 10   2
## 22278 ripkeca01   1989 162 646  80 166  30   0 21  93  3  2  57  0  6   3
## 22279 ripkeca01   1990 161 600  78 150  28   4 21  84  3  1  82  1  7   5
## 22280 ripkeca01   1991 162 650  99 210  46   5 34 114  6  1  53  0  9   5
## 22281 ripkeca01   1992 162 637  73 160  29   1 14  72  4  3  64  0  7   7
## 22282 ripkeca01   1993 162 641  87 165  26   3 24  90  1  4  65  0  6   6
## 22283 ripkeca01   1994 112 444  71 140  19   3 13  75  1  0  32  0  4   4
## 22284 ripkeca01   1995 144 550  71 144  33   2 17  88  0  1  52  1  8   2
## 22285 ripkeca01   1996 163 640  94 178  40   1 26 102  1  2  59  0  4   4
## 22286 ripkeca01   1997 162 615  79 166  30   0 17  84  1  0  56  0 10   5
## 22287 ripkeca01   1998 161 601  65 163  27   1 14  61  0  2  51  1  2   4
## 22288 ripkeca01   1999  86 332  51 113  27   0 18  57  0  1  13  3  3   3
## 22289 ripkeca01   2000  83 309  43  79  16   0 15  56  0  0  23  0  4   3
## 22290 ripkeca01   2001 128 477  43 114  16   0 14  68  0  2  26  2  9   2
## 27342 wagneho01   1897  61 237  37  80  17   4  2  39 19 NA  15  5  0   1
## 27343 wagneho01   1898 151 588  80 176  29   3 10 105 27 NA  31 10  0   6
## 27344 wagneho01   1899 147 571  98 192  43  13  7 113 37 NA  40  4  0  11
## 27345 wagneho01   1900 135 527 107 201  45  22  4 100 38 NA  41  4  0   8
## 27346 wagneho01   1901 140 549 101 194  37  11  6 126 49 NA  53 10  0   7
## 27347 wagneho01   1902 136 534 105 176  30  16  3  91 42 NA  43  8  0  14
## 27348 wagneho01   1903 129 512  97 182  30  19  5 101 46 NA  44  8  0   7
## 27349 wagneho01   1904 132 490  97 171  44  14  4  75 53 NA  59  5  0   4
## 27350 wagneho01   1905 147 548 114 199  32  14  6 101 57 NA  54  7  0   7
## 27351 wagneho01   1906 142 516 103 175  38   9  2  71 53 NA  58  6  0  10
## 27352 wagneho01   1907 142 515  98 180  38  14  6  82 61 NA  46 14  0   5
## 27353 wagneho01   1908 151 568 100 201  39  19 10 109 53 NA  54 14  0   5
## 27354 wagneho01   1909 137 495  92 168  39  10  5 100 35 NA  66 27  0   3
## 27355 wagneho01   1910 150 556  90 178  34   8  4  81 24 NA  59 20  0   5
## 27356 wagneho01   1911 130 473  87 158  23  16  9  89 20 NA  67 12  0   6
## 27357 wagneho01   1912 145 558  91 181  35  20  7 102 26 NA  59 11  0   6
## 27358 wagneho01   1913 114 413  51 124  18   4  3  56 21 NA  26 10  0   5
## 27359 wagneho01   1914 150 552  60 139  15   9  1  50 23 NA  51 11  0   2
## 27360 wagneho01   1915 156 566  68 155  32  17  6  78 22 15  39 16  0   4
## 27361 wagneho01   1916 123 432  45 124  15   9  1  39 11 NA  34 10  0   8
## 27362 wagneho01   1917  74 230  15  61   7   1  0  24  5 NA  24  9  0   1
## 29263 yountro01   1974 107 344  48  86  14   5  3  26  7  7  12  5  2   1
## 29264 yountro01   1975 147 558  67 149  28   2  8  52 12  4  33 10  5   1
## 29265 yountro01   1976 161 638  59 161  19   3  2  54 16 11  38  8  6   0
## 29266 yountro01   1977 154 605  66 174  34   4  4  49 16  7  41 11  4   2
## 29267 yountro01   1978 127 502  66 147  23   9  9  71 16  5  24 13  5   1
## 29268 yountro01   1979 149 577  72 154  26   5  8  51 11  8  35 10  3   1
## 29269 yountro01   1980 143 611 121 179  49  10 23  87 20  5  26  6  3   1
## 29270 yountro01   1981  96 377  50 103  15   5 10  49  4  1  22  4  6   2
## 29271 yountro01   1982 156 635 129 210  46  12 29 114 14  3  54  4 10   1
## 29272 yountro01   1983 149 578 102 178  42  10 17  80 12  5  72  1  8   3
## 29273 yountro01   1984 160 624 105 186  27   7 16  80 14  4  67  1  9   1
## 29274 yountro01   1985 122 466  76 129  26   3 15  68 10  4  49  1  9   2
## 29275 yountro01   1986 140 522  82 163  31   7  9  46 14  5  62  5  2   4
## 29276 yountro01   1987 158 635  99 198  25   9 21 103 19  9  76  6  5   1
## 29277 yountro01   1988 162 621  92 190  38  11 13  91 22  4  63  2  7   3
## 29278 yountro01   1989 160 614 101 195  38   9 21 103 19  3  63  3  4   6
## 29279 yountro01   1990 158 587  98 145  17   5 17  77 15  8  78  4  8   6
## 29280 yountro01   1991 130 503  66 131  20   4 10  77  6  4  54  1  9   4
## 29281 yountro01   1992 150 557  71 147  40   3  8  77 15  6  53  4 12   3
## 29282 yountro01   1993 127 454  62 117  25   3  8  51  9  2  44  5  6   5
##             SLG       OBP       OPS Career.AB POS Birthyear Age
## 296   0.3816514 0.3277311 0.7093825      9073  2B      1968  20
## 297   0.3756019 0.3474453 0.7230472      9073  2B      1968  21
## 298   0.3805461 0.3400936 0.7206397      9073  2B      1968  22
## 299   0.4364207 0.3541963 0.7906170      9073  2B      1968  23
## 300   0.4273205 0.4045113 0.8318318      9073  2B      1968  24
## 301   0.4923599 0.4079529 0.9003128      9073  2B      1968  25
## 302   0.4515306 0.3861607 0.8376913      9073  2B      1968  26
## 303   0.4487427 0.3537653 0.8025081      9073  2B      1968  27
## 304   0.5272109 0.4109986 0.9382094      9073  2B      1968  28
## 305   0.5000000 0.3896104 0.8896104      9073  2B      1968  29
## 306   0.4183673 0.3470948 0.7654621      9073  2B      1968  30
## 307   0.5328597 0.4222874 0.9551471      9073  2B      1968  31
## 308   0.4754098 0.3775510 0.8529609      9073  2B      1968  32
## 309   0.5408696 0.4146707 0.9555402      9073  2B      1968  33
## 310   0.3762712 0.3312789 0.7075501      9073  2B      1968  34
## 311   0.3488372 0.3327645 0.6816017      9073  2B      1968  35
## 312   0.3918129 0.3208556 0.7126685      9073  2B      1968  36
## 1993  0.3495935 0.2538462 0.6034396     10876  2B      1966  22
## 1994  0.4018059 0.3359841 0.7377900     10876  2B      1966  23
## 1995  0.3477477 0.3415033 0.6892510     10876  2B      1966  24
## 1996  0.3736264 0.3576159 0.7312423     10876  2B      1966  25
## 1997  0.3686786 0.3784916 0.7471702     10876  2B      1966  26
## 1998  0.4737705 0.3732194 0.8469899     10876  2B      1966  27
## 1999  0.4828375 0.4106090 0.8934466     10876  2B      1966  28
## 2000  0.4828210 0.4063444 0.8891654     10876  2B      1966  29
## 2001  0.4148760 0.3860140 0.8008900     10876  2B      1966  30
## 2002  0.5008078 0.4153226 0.9161303     10876  2B      1966  31
## 2003  0.5030960 0.4029851 0.9060810     10876  2B      1966  32
## 2004  0.4569640 0.3857527 0.8427167     10876  2B      1966  33
## 2005  0.3925729 0.3877996 0.7803725     10876  2B      1966  34
## 2006  0.4554295 0.3821478 0.8375773     10876  2B      1966  35
## 2007  0.4038128 0.3297214 0.7335342     10876  2B      1966  36
## 2008  0.4124204 0.3501401 0.7625604     10876  2B      1966  37
## 2009  0.4691943 0.3371925 0.8063868     10876  2B      1966  38
## 2010  0.4677966 0.3245750 0.7923716     10876  2B      1966  39
## 2011  0.4215328 0.3056478 0.7271807     10876  2B      1966  40
## 2012  0.3810445 0.2846715 0.6657160     10876  2B      1966  41
## 8725  0.3103448 0.3225806 0.6329255      8677  SS      1959  23
## 8726  0.3875000 0.3058824 0.6933824      8677  SS      1959  24
## 8727  0.3480243 0.3305439 0.6785682      8677  SS      1959  25
## 8728  0.3805031 0.3428165 0.7233196      8677  SS      1959  26
## 8729  0.4223706 0.3380503 0.7604209      8677  SS      1959  27
## 8730  0.4282828 0.3892857 0.8175685      8677  SS      1959  28
## 8731  0.4094617 0.3614815 0.7709431      8677  SS      1959  29
## 8732  0.4616788 0.3864734 0.8481523      8677  SS      1959  30
## 8733  0.4020619 0.3832335 0.7852954      8677  SS      1959  31
## 8734  0.4736842 0.4081942 0.8818784      8677  SS      1959  32
## 8735  0.3551402 0.3278689 0.6830090      8677  SS      1959  33
## 8736  0.4379699 0.3604651 0.7984350      8677  SS      1959  34
## 8737  0.5103926 0.4059406 0.9163332      8677  SS      1959  35
## 8738  0.4699074 0.4068136 0.8767210      8677  SS      1959  37
## 8739  0.3604651 0.3690476 0.7295127      8677  SS      1959  38
## 8740  0.0000000 0.0000000 0.0000000      8677  SS      1959  40
## 8741  0.4444444 0.3762376 0.8206821      8677  SS      1959  42
## 8742  0.3816568 0.3569554 0.7386122      8677  SS      1959  43
## 8743  0.4517766 0.3721973 0.8239740      8677  SS      1959  44
## 8744  0.4406250 0.3777778 0.8184028      8677  SS      1959  45
## 8745  0.4506438 0.3484848 0.7991286      8677  SS      1959  46
## 8746  0.3696970 0.3296089 0.6993059      8677  SS      1959  47
## 8747  0.2888889 0.3207547 0.6096436      8677  SS      1959  48
## 9368  0.4615385 0.4615385 0.9230769      8860  2B      1903  21
## 9369  0.1666667 0.2500000 0.4166667      8860  2B      1903  22
## 9370  0.3986928 0.3224490 0.7211418      8860  2B      1903  23
## 9371  0.4409449 0.3825623 0.8235072      8860  2B      1903  24
## 9372  0.4510779 0.3952802 0.8463582      8860  2B      1903  25
## 9373  0.5315457 0.4048295 0.9363753      8860  2B      1903  26
## 9374  0.5344262 0.4037901 0.9382163      8860  2B      1903  27
## 9375  0.4308094 0.3592233 0.7900327      8860  2B      1903  28
## 9376  0.4967638 0.3701016 0.8668654      8860  2B      1903  29
## 9377  0.4681529 0.3934192 0.8615720      8860  2B      1903  30
## 9378  0.5174709 0.4495021 0.9669730      8860  2B      1903  31
## 9379  0.5016393 0.4089595 0.9105989      8860  2B      1903  32
## 9380  0.5553822 0.4313187 0.9867009      8860  2B      1903  33
## 9381  0.5195035 0.4580153 0.9775188      8860  2B      1903  34
## 9382  0.4859155 0.4248175 0.9107330      8860  2B      1903  35
## 9383  0.5443350 0.4231579 0.9674929      8860  2B      1903  36
## 9384  0.4466019 0.4281099 0.8747118      8860  2B      1903  37
## 9385  0.3027523 0.3632959 0.6660482      8860  2B      1903  38
## 9386  0.3333333 0.3653846 0.6987179      8860  2B      1903  39
## 13241 0.3750000 0.2941176 0.6691176     11195  SS      1974  21
## 13242 0.4295533 0.3703704 0.7999236     11195  SS      1974  22
## 13243 0.4051988 0.3702703 0.7754690     11195  SS      1974  23
## 13244 0.4808307 0.3835022 0.8643328     11195  SS      1974  24
## 13245 0.5518341 0.4375000 0.9893341     11195  SS      1974  25
## 13246 0.4806071 0.4156805 0.8962876     11195  SS      1974  26
## 13247 0.4804560 0.3773862 0.8578422     11195  SS      1974  27
## 13248 0.4208075 0.3727648 0.7935722     11195  SS      1974  28
## 13249 0.4502075 0.3933210 0.8435284     11195  SS      1974  29
## 13250 0.4712286 0.3517730 0.8230017     11195  SS      1974  30
## 13251 0.4495413 0.3892617 0.8388030     11195  SS      1974  31
## 13252 0.4831461 0.4166667 0.8998127     11195  SS      1974  32
## 13253 0.4522692 0.3881857 0.8404548     11195  SS      1974  33
## 13254 0.4077181 0.3630862 0.7708044     11195  SS      1974  34
## 13255 0.4652997 0.4058989 0.8711986     11195  SS      1974  35
## 13256 0.3695324 0.3401084 0.7096408     11195  SS      1974  36
## 13257 0.3882784 0.3548922 0.7431706     11195  SS      1974  37
## 13258 0.4289898 0.3623978 0.7913876     11195  SS      1974  38
## 13259 0.2539683 0.2876712 0.5416395     11195  SS      1974  39
## 13260 0.3132530 0.3035144 0.6167674     11195  SS      1974  40
## 18447 0.3723608 0.3005464 0.6729073     10835  DH      1957  21
## 18448 0.4691781 0.3724570 0.8416350     10835  DH      1957  22
## 18449 0.4377778 0.3715415 0.8093193     10835  DH      1957  23
## 18450 0.3346614 0.3405018 0.6751631     10835  DH      1957  24
## 18451 0.4504505 0.3657220 0.8161724     10835  DH      1957  25
## 18452 0.4095395 0.3333333 0.7428728     10835  DH      1957  26
## 18453 0.2391304 0.2448980 0.4840284     10835  DH      1957  27
## 18454 0.4079861 0.3559055 0.7638916     10835  DH      1957  28
## 18455 0.4256293 0.3395833 0.7652126     10835  DH      1957  29
## 18456 0.5655914 0.4376164 1.0032078     10835  DH      1957  30
## 18457 0.4515599 0.3839416 0.8355015     10835  DH      1957  31
## 18458 0.4390244 0.3786127 0.8176371     10835  DH      1957  32
## 18459 0.4641148 0.3427948 0.8069096     10835  DH      1957  33
## 18460 0.4887218 0.3991989 0.8879207     10835  DH      1957  34
## 18461 0.4614122 0.3893678 0.8507800     10835  DH      1957  35
## 18462 0.5094340 0.4019337 0.9113677     10835  DH      1957  36
## 18463 0.5176211 0.4097087 0.9273299     10835  DH      1957  37
## 18464 0.4228571 0.3495798 0.7724370     10835  DH      1957  38
## 18465 0.4681818 0.3901099 0.8582917     10835  DH      1957  39
## 18466 0.4349442 0.3512605 0.7862047     10835  DH      1957  40
## 18467 0.3824701 0.3351254 0.7175956     10835  DH      1957  41
## 22270 0.1282051 0.1500000 0.2782051     11551  SS      1961  20
## 22271 0.4749164 0.3169985 0.7919149     11551  SS      1961  21
## 22272 0.5173454 0.3705234 0.8878688     11551  SS      1961  22
## 22273 0.5101404 0.3743017 0.8844421     11551  SS      1961  23
## 22274 0.4688474 0.3467967 0.8156440     11551  SS      1961  24
## 22275 0.4609250 0.3550212 0.8159463     11551  SS      1961  25
## 22276 0.4358974 0.3333333 0.7692308     11551  SS      1961  26
## 22277 0.4313043 0.3715530 0.8028573     11551  SS      1961  27
## 22278 0.4009288 0.3174157 0.7183445     11551  SS      1961  28
## 22279 0.4150000 0.3414986 0.7564986     11551  SS      1961  29
## 22280 0.5661538 0.3737796 0.9399335     11551  SS      1961  30
## 22281 0.3657771 0.3230769 0.6888540     11551  SS      1961  31
## 22282 0.4196568 0.3286908 0.7483476     11551  SS      1961  32
## 22283 0.4594595 0.3636364 0.8230958     11551  SS      1961  33
## 22284 0.4218182 0.3235294 0.7453476     11551  SS      1961  34
## 22285 0.4656250 0.3408769 0.8065019     11551  SS      1961  35
## 22286 0.4016260 0.3309038 0.7325298     11551  SS      1961  36
## 22287 0.3893511 0.3313070 0.7206581     11551  SS      1961  37
## 22288 0.5843373 0.3675214 0.9518587     11551  SS      1961  38
## 22289 0.4530744 0.3097345 0.7628089     11551  SS      1961  39
## 22290 0.3605870 0.2762646 0.6368516     11551  SS      1961  40
## 27342 0.4683544 0.3794466 0.8478011     10430  SS      1874  23
## 27343 0.4098639 0.3408000 0.7506639     10430  SS      1874  24
## 27344 0.4938704 0.3906752 0.8845456     10430  SS      1874  25
## 27345 0.5730550 0.4340278 1.0070828     10430  SS      1874  26
## 27346 0.4936248 0.4170772 0.9107019     10430  SS      1874  27
## 27347 0.4625468 0.3942470 0.8567939     10430  SS      1874  28
## 27348 0.5175781 0.4138544 0.9314325     10430  SS      1874  29
## 27349 0.5204082 0.4231465 0.9435546     10430  SS      1874  30
## 27350 0.5054745 0.4269294 0.9324038     10430  SS      1874  31
## 27351 0.4593023 0.4160959 0.8753982     10430  SS      1874  32
## 27352 0.5126214 0.4081272 0.9207486     10430  SS      1874  33
## 27353 0.5422535 0.4146730 0.9569266     10430  SS      1874  34
## 27354 0.4888889 0.4202128 0.9091017     10430  SS      1874  35
## 27355 0.4316547 0.3903226 0.8219773     10430  SS      1874  36
## 27356 0.5073996 0.4230769 0.9304765     10430  SS      1874  37
## 27357 0.4964158 0.3948636 0.8912793     10430  SS      1874  38
## 27358 0.3849879 0.3490991 0.7340870     10430  SS      1874  39
## 27359 0.3170290 0.3173554 0.6343844     10430  SS      1874  40
## 27360 0.4222615 0.3251232 0.7473846     10430  SS      1874  41
## 27361 0.3703704 0.3502110 0.7205813     10430  SS      1874  42
## 27362 0.3043478 0.3372549 0.6416027     10430  SS      1874  43
## 29263 0.3459302 0.2757660 0.6216962     11008  SS      1956  18
## 29264 0.3673835 0.3065327 0.6739162     11008  SS      1956  19
## 29265 0.3009404 0.2917889 0.5927293     11008  SS      1956  20
## 29266 0.3768595 0.3328221 0.7096816     11008  SS      1956  21
## 29267 0.4282869 0.3233083 0.7515951     11008  SS      1956  22
## 29268 0.3708839 0.3084416 0.6793254     11008  SS      1956  23
## 29269 0.5188216 0.3213729 0.8401945     11008  SS      1956  24
## 29270 0.4190981 0.3120393 0.7311375     11008  SS      1956  25
## 29271 0.5779528 0.3785714 0.9565242     11008  SS      1956  26
## 29272 0.5034602 0.3827534 0.8862136     11008  SS      1956  27
## 29273 0.4407051 0.3623395 0.8030446     11008  SS      1956  28
## 29274 0.4420601 0.3422053 0.7842654     11008  SS      1956  29
## 29275 0.4501916 0.3881356 0.8383272     11008  SS      1956  30
## 29276 0.4787402 0.3835425 0.8622827     11008  SS      1956  31
## 29277 0.4653784 0.3688761 0.8342545     11008  SS      1956  32
## 29278 0.5114007 0.3842795 0.8956801     11008  SS      1956  33
## 29279 0.3798978 0.3372607 0.7171585     11008  SS      1956  34
## 29280 0.3757455 0.3315789 0.7073245     11008  SS      1956  35
## 29281 0.3895871 0.3248000 0.7143871     11008  SS      1956  36
## 29282 0.3788546 0.3261297 0.7049843     11008  SS      1956  37
```


