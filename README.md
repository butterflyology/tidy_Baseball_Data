Repository for my "tidy" version of code and figures to accompany **Analyzing Baseball Data with R** by Marchi and Albert 2014

The purpose of this repo is to present the data parsing and figures in a different way. The analyses in the book are fully reproducible, which is **extremely** important. Everything else comes down to personal preference. I made this repo because I wanted to improve my skills with respects to the "tidy" universe of packages. With that said, there are a few points where the tidy code is so much faster or cleaner than I will draw your attention to it. 

The "tidy" paradigm (aka "tidy-verse" formerly the "Hadley-verse") is just one way of working with data and making figures. The book does a good job presenting concepts and analyses, I just wanted to present a different way of doing many of the same things. Here, I use the *dply* package whenever possible to work with and manipulate data. I also used *ggplot2* to generate figures. 

All data (and the original code) are available on github here: **https://github.com/maxtoki/baseball_R**

I hope that you are following along with the book, otherwise this may not make a lot of sense. 

I've tried to name the code chunks in a way that makes sense. For example, the code for Section 5.2 is labelled Sec_5.2. Similarly, the code for Figure 6.4 is labelled Fig_6.4.

I will be downloading the data remotely or using the Lahman package so the repo is not filled with large files. If you are following along at home you may want to clone the repo or download the data locally. 

*If there are errors or you found a better way for me to do something, pretty please submit a PR*.

**2016 Commits:**

1. 2016-07-31 - Initial commit (README.md)
1. 2016-08-07 - Updated Ch. 2 file to include exercises
1. 2016-09-09 - Completed Ch. 2 & 3 questions at the end of the chapter. 
1. 2016-08-16 - Completed Ch. 4 and three end of chapter questions.
1. 2016-08-20 - Uploaded Ch. 5, exercises, and added a table with EVENT_CD codes explained. 
1. 2016-08-22 - Uploaded Ch. 6 code and exercises.
1. 2016-08-24 - Cleaned code and centered figures.
1. 2016-08-28 - Fixed figures in Ch.2, began work on Ch.7 
1. 2016-10-04 - Found error in code for Figure 5.2, began Ch.7, used the "tidyverse" package rather than a la carte packages.  
1. 2016-10-13 - Cleaned the RMarkdown code by setting global with opts_chunk$set.
1. 2016-11-15 - Added Chapter 8 material and cleaned earlier chapters.
1. 2017-08-04 - Updated figures, started `bookdown` branch.
