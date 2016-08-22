#R baseball
library("Lahman")
# library("plyr")
library("dplyr"); options(dplyr.width = Inf)
library("ggplot2")
library("readr")

set.seed(8761825)

setwd("~/Desktop/Projects/Baseball_R")

sessionInfo()
#####
##### Chapter 1
#####

## Section 1.2.3 The Master table - everyone that has even been in the majors
master <- read_csv("2016_core/core/Master.csv", col_names = TRUE)
head(Master)
dim(Master)
str(Master)
which(Master$playerID == "aaronha01")
Master[2, ]
which(Master$nameLast == "Seager")
Master[15098, ]
which(Master$nameLast == "Kennedy" & Master$nameFirst == "Kevin")
Master[8778, ]
which(Master$nameLast == "Green" & Master$nameFirst == "Shawn")
Master[6457, ]

# batting table
Batting <- read_csv("2016_core/core/Batting.csv", col_names = TRUE)
dim(Batting)
head(Batting)
str(Batting)
Batting[9567, ]

HR_decade <- Batting %>% group_by(yearID) %>% summarise(mean_year = mean(HR, na.rm = TRUE))


Pitching <- read_csv("2016_core/core/Pitching.csv", col_names = TRUE)
dim(Pitching)
head(Pitching)

Fielding <- read_csv("2016_core/core/Fielding.csv", col_names = TRUE)
dim(Fielding)

Teams <- read_csv("2016_core/core/Teams.csv", col_names = TRUE)
dim(Teams)
head(Teams)


#####
##### Chapter 2
#####

# Section 2.6
NL <- c("FLA", "STL", "HOU", "STL", "COL", "PHI", "PHI", "SFG", "STL", "SFG")
AL <- c("NYY", "BOS", "CHW", "DET", "BOS", "TBR", "NYY", "TEX", "TEX", "DET")
Winner <- c("NL", "AL", "AL", "NL", "NL", "NL", "AL", "NL", "NL", "NL")
N.Games <- c(6, 4, 4, 5, 4, 5, 6, 5, 7, 4)
Year <- 2003 : 2012

results <- matrix(c(NL, AL), 10, 2)
results

dimnames(results)[[1]] <- Year
dimnames(results)[[2]] <- c("NL Team", "AL Team")
results

table(Winner)
barplot(table(Winner), las = 1)

NL2 <- factor(NL, levels=c("FLA", "PHI", "HOU", "STL", "COL", "SFG"))
str(NL2)
table(NL2)

World.Series <- list(Winner = Winner, Number.Games = N.Games, Seasons = "2003 to 2012")

World.Series$Number.Games
World.Series[[2]]

hr.rates <- function(age, hr, ab){	rates <- round(100 * hr / ab, 1)	list(x = age, y = rates)}

HR <- c(13, 23, 21, 27, 37, 52, 34, 42, 31, 40, 54)AB <- c(341, 549, 461, 543, 517, 533, 474, 519, 541, 527, 514)Age <- 19 : 29hr.rates(age = Age, hr = HR, ab = AB)
plot(hr.rates(age = Age, hr = HR, ab = AB), pch = 19, las = 1, ylab = "Home run rate", xlab = "AGE", cex = 1.5)

Spahn <- read_csv("baseball_R-master/data/spahn.csv", col_names = TRUE)
head(Spahn)
dim(Spahn)
str(Spahn)

Spahn <- Spahn %>% mutate(FIP = ((13 * HR) + (3 * BB) -2 * SO) / IP)
pos <- order(Spahn$FIP)
head(Spahn[pos, c("Year", "Age", "W", "L", "ERA", "FIP")])

Spahn1 <- Spahn %>% filter(Tm == "BSN" | Tm == "MLN") %>% mutate(Tm = factor(Tm, levels = c("BSN", "MLN")))
by(Spahn1[, c("W-L", "ERA", "WHIP", "FIP")], Spahn1$Tm, summary)


## Section 2.7.3

NLbatting <- read_csv("baseball_R-master/data/NLbatting.csv", col_names = TRUE)
head(NLbatting)
dim(NLbatting)

ALbatting <- read_csv("baseball_R-master/data/ALbatting.csv", col_names = TRUE)
head(ALbatting)

batting <- rbind(NLbatting, ALbatting)
head(batting)

NLpitching <- read_csv("baseball_R-master/data/NLpitching.csv", col_names = TRUE)
head(NLpitching)
NL <- merge(NLbatting, NLpitching, by = "Tm")
head(NL)
dim(NL)

NL.150 <- NLbatting %>% filter(HR > 150)
NL.150


# split apply combine, should use dplyr now
Batting <- read_csv("2016_core/core/Batting.csv", col_names = TRUE)
head(Batting)
dim(Batting)

Batting.60 <- Batting %>% filter(yearID >= 1960 & yearID <= 1969)
head(Batting.60)
dim(Batting.60)
max(Batting.60$yearID)
min(Batting.60$yearID)

compute.hr <- function(pid){
	d <- Batting.60 %>% filter(playerID == pid)
	sum(d$HR)
}

players <- unique(Batting.60$playerID)
system.time(S <- sapply(players, compute.hr))
head(S)
length(S) #1786 players had home runs


R <- data.frame(Player = players, HR = S)
R <- R[order(R$HR, decreasing = TRUE), ]
head(R)
dim(R) # This is the as the tidy data object we've already made

# create a data frame 
dataframe.AB <- Batting %>% select(playerID, AB, HR, SO) %>% group_by(playerID) %>% filter(!is.na(AB)) %>% summarize(AB = sum(AB), HR = sum(HR), SO = sum(SO))

head(dataframe.AB)
dim(dataframe.AB)

# Note here that merging as described in the book makes no sense. Why add repeated rows of summarized data back to the original data frame "Batting?"

Batting2 <- dplyr::full_join(Batting, dataframe.AB, by = "playerID")
head(Batting2)
dim(Batting2)


Batting.5000 <- dataframe.AB %>% filter(AB >= 5000)
dim(Batting.5000)
head(Batting.5000)


# This function is now a bit silly, as we have already calculated the relevent statistics. See how, with one line of dplyr code, we can replace a function and other awkward subsetting.
ab.hr.so <- function(d){
	c.AB <- sum(d$AB, na.rm = TRUE)
	c.HR <- sum(d$HR, na.rm = TRUE)
	c.SO <- sum(d$SO, na.rm = TRUE)
	data.frame(AB = c.AB, HR = c.HR, SO = c.SO)
}


aaron <- subset(Batting.5000, playerID == "aaronha01")
ab.hr.so(aaron)


# Recreate figure 2.8, where we want to plot the SO/AB (Y) against the HR/AB (X)
ggplot(Batting.5000, aes(x = HR / AB, y = SO / AB)) + geom_point(cex = 2) + stat_smooth(method = "loess", col = "red") + theme_bw() + ylab("SO / AB") + xlab("HR / AB")


#####
##### Chapter 3
#####

hof <- read_csv("baseball_R-master/data/hofbatting.csv", col_names = TRUE, trim_ws = TRUE)
head(hof)
dim(hof)


# Rather than multiple additions to the data, lets create all of the variables we are interested in all at once. 
hof <- hof %>% mutate(MidCareer = ((From + To) / 2), Era = cut(MidCareer, breaks = c(1800, 1900, 1919, 1941, 1960, 1976, 1993, 2050), labels=c("19th Century", "Lively Ball", "Dead Ball", "Integration", "Expansion", "Free Agency", "Long Ball")), HR.Rate = (HR / AB)) %>% rename(Name = X2)
head(hof)
# Let's get rid of the " HOF" in the name column
hof[, 2] <- gsub(" HOF", "", hof$Name)
head(hof)

# Using ggplot we don't need to create a table

# figure 3.1
ggplot(hof, aes(x = Era)) + theme_bw() + geom_bar() + ylab("Frequency") + xlab("Era") + ggtitle("Era of the Nonpitching Hall of Famers")


# Figure 3.2 - These are ugly but require nothing special to plot. Note, if you call the code exactly as printed you will not get the the images depicted in the book. 
par(mfrow = c(1, 2))
plot(table(hof$Era), ylab = "T", las = 1)
pie(table(hof$Era))


### Figure 3.3, a Clevelnd dot plot of HoFers by Era. I am having trouble with this. This may be the first time I haven't been able to get ggplot to do what I want.
T.era <- table(hof$Era)
T.era
dotchart(as.numeric(T.era), labels = names(T.era), xlab = "Frequency", ylab = "", pt.cex = 2, pch = 19) # note that there is a discrepency int the code on page 64 (naming the object "T.Era"), in previous example it is called "T.era."
# ggplot(hof, aes(y = Era, x = )) + geom_point(size = 2) # can't get ggplot to count the frequency of occurance. It can do that with a bar chart but not with geom_points(), to the best of my knowledge.

### Figure 3.4 - No need to subset priot to plotting, we can do it inline with the plot call. 
ggplot(hof %>% filter(HR >= 500), aes(y = reorder(, OPS), x = OPS)) + geom_point(size = 3) + theme_bw() + theme(panel.grid.major.x = element_blank(), panel.grid.minor.y = element_blank(), panel.grid.major.y = element_line(color = "grey60", linetype = "dashed")) + ylab("") + xlab("OPS")
 
 
# Figure 3.5 - I can't seem to do make this figure with ggplot.
stripchart(hof$MidCareer, method = "jitter", pch = 19, xlab = "Mid Career")

# Figure 3.6
ggplot(hof, aes(x = MidCareer)) + geom_histogram(binwidth = 5, fill = "grey", color = "black") + ylab("Frequency") + ylab("Frequency") + theme_bw()


# Figure 3.7
ggplot(hof, aes(x = MidCareer, y = OPS)) + geom_point(size = 2) + stat_smooth(method = "loess", col = "black", se = FALSE) + theme_bw()


# Figure 3.8
ggplot(hof, aes(x = OBP, y = SLG)) + geom_point(size = 2.5) + theme_bw() + xlab("On-Base Percentage") + ylab("Slugging Percentage")

# Figure 3.9 (Changing the axes limits)
ggplot(hof, aes(x = OBP, y = SLG)) + geom_point(size = 2.5) + theme_bw() + ylim(0.28, 0.75) + xlim(0.25, 0.50) + xlab("On-Base Percentage") + ylab("Slugging Percentage")

# Figure 3.10 (with lines delimiting OPS)
ggplot(hof, aes(x = OBP, y = SLG)) + geom_point(size = 2.5) + theme_bw() + ylim(0.28, 0.75) + xlim(0.25, 0.50) + xlab("On-Base Percentage") + ylab("Slugging Percentage") + stat_function(fun = function(x) 0.7 - x) + stat_function(fun = function(x) 0.8 - x) + stat_function(fun = function(x) 0.9 - x) + stat_function(fun = function(x) 1.0 - x) + annotate("text", x = 0.27, y = c(0.42, 0.52, 0.62, 0.72), label = c("OPS = 0.7", "OPS = 0.8", "OPS = 0.9", "OPS = 1.0"))


## plotting numeric and factor variables
# stripcharts

# Figure 3.12
stripchart(HR.Rate ~ Era, data = hof, pch = 19, ylab = "", method = "jitter")

par(plt = c(0.2, 0.95, 0.145, 0.883))
stripchart(HR.Rate ~ Era, data = hof, pch = 19, ylab = "", method = "jitter", las = 1)

# Figure 3.13
ggplot(hof, aes(y = HR.Rate, x = Era)) + geom_boxplot(outlier.size = 2, stat = "boxplot") + coord_flip() + theme_bw() + xlab("") + ylab("HR Rate")


## Section 3.8
master <- read_csv("2016_core/core/Master.csv", col_names = TRUE)
head(master)
str(master)

# comparing Ruth, Aaron, Bonds, and A-Rod
getinfo <- function(firstname, lastname){
	playerline <- subset(master, nameFirst == firstname & nameLast == lastname)
	name.code <- as.character(playerline$playerID)
	birthyear <- playerline$birthYear
	birthmonth <- playerline$birthMonth
	birthday <- playerline$birthDay
	byear <- ifelse(birthmonth <= 6, birthyear, birthyear + 1)
	list(name.code = name.code, byear = byear)
}

ruth.info <- getinfo("Babe", "Ruth")
aaron.info <- getinfo("Hank", "Aaron")
bonds.info <- getinfo("Barry", "Bonds")
arod.info <- getinfo("Alex", "Rodriguez")
ruth.info

batting <- read_csv("2016_core/core/batting.csv", col_names = TRUE)
str(batting)

# This is how the book created the data
ruth.data <- subset(batting, playerID == ruth.info$name.code)
ruth.data$Age <- ruth.data$yearID - ruth.info$byear
dim(ruth.data)
head(ruth.data)

# I rewrote this to use dplyr
ruth.data <- batting %>% filter(playerID == ruth.info$name.code) %>% mutate(Age = yearID - ruth.info$byear)

aaron.data <- batting %>% filter(playerID == aaron.info$name.code) %>% mutate(Age = yearID - aaron.info$byear)

bonds.data <- batting %>% filter(playerID == bonds.info$name.code) %>% mutate(Age = yearID - bonds.info$byear)

arod.data <- batting %>% filter(playerID == arod.info$name.code) %>% mutate(Age = yearID - arod.info$byear)


with(ruth.data, plot(Age, cumsum(HR), type = "l", lty = 3, lwd = 2, xlab = "Age", ylab = "Career HR", xlim = c(18, 45), ylim = c(0, 800), las = 1))
with(aaron.data, lines(Age, cumsum(HR), lty = 2, lwd = 2))
with(bonds.data, lines(Age, cumsum(HR), lty = 1, lwd = 2))
with(arod.data, lines(Age, cumsum(HR), lty = 4, lwd = 2))
legend("topleft", legend = c("Ruth", "Aaron", "Bonds", "Arod"), lty = c(3, 2, 1, 4), lwd = 2, bty = "n")

# just playing around
with(ruth.data, plot(yearID, cumsum(HR), type = "l", lty = 3, lwd = 2, xlab = "Year", ylab = "Career HR", xlim = c(1910, 2015), ylim = c(0, 800), las = 1))
with(aaron.data, lines(yearID, cumsum(HR), lty = 2, lwd = 2))
with(bonds.data, lines(yearID, cumsum(HR), lty = 1, lwd = 2))
with(arod.data, lines(yearID, cumsum(HR), lty = 4, lwd = 2))
legend("topleft", legend = c("Ruth", "Aaron", "Bonds", "Arod"), lty = c(3, 2, 1, 4), lwd = 2, bty = "n")


### Section 3.9 - The 1998 home run race
# Look at how f-ing fast readr is!!!
system.time(data1998 <- read_csv("baseball_R-master/data/all1998.csv", col_names = FALSE))

system.time(data1998 <- read.csv("baseball_R-master/data/all1998.csv", header = FALSE))

fields <- read_csv("baseball_R-master/data/fields.csv", col_names = TRUE)
names(data1998) <- fields[, "Header"]

# need to parse out player IDs
retro.ids <- read_csv("baseball_R-master/data/retrosheetIDs.csv", col_names = TRUE)
head(retro.ids)

sosa.id <- as.character(subset(retro.ids, FIRST == "Sammy" & LAST == "Sosa")$ID)
mac.id <- as.character(subset(retro.ids, FIRST == "Mark" & LAST == "McGwire")$ID)

sosa.data <- data1998 %>% filter(BAT_ID == sosa.id)
mac.data <- data1998 %>% filter(BAT_ID == mac.id)
dim(sosa.data); dim(mac.data)


# write function to extract variables
createdata <- function(d){
	d$Date <- as.Date(substr(d$GAME_ID, 4, 11), format = "%Y%m%d")
	d <- d[order(d$Date), ]
	d$HR <- ifelse(d$EVENT_CD == 23, 1, 0)
	d$cumHR <- cumsum(d$HR)
	d[, c("Date", "cumHR")]
}

sosa.hr <- createdata(sosa.data)
mac.hr <- createdata(mac.data)
head(sosa.hr); head(mac.hr)

plot(mac.hr, type = "l", lwd = 2, ylab = "HR in 1998", las = 1)
lines(sosa.hr, lwd = 2, col = "grey")
abline(h = 62, lty = 3, lwd = 2)
text(10405, 65, "62")
legend("topleft", legend = c("McGwire (70)", "Sosa (66)"), lwd = 2, col = c("black", "grey"), bty = "n")

#####
##### Chapter 4
#####

teams <- read_csv("2016_core/core/Teams.csv", col_names = TRUE)
tail(teams)
dim(teams)
LAD1988 <- teams %>% filter(yearID == 1988 & franchID == "LAD")
LAD1988

## attendence detour
attd <- teams %>% select(franchID, attendance, yearID) %>% filter(attendance > 0)
tail(attd)

LADattd <- teams %>% filter(franchID == "LAD") %>% select(attendance, yearID)
tail(LADattd)
ggplot(LADattd, aes(y = attendance, x = yearID)) + geom_line(size = 1.5) + theme_bw() + ylab("Attendance") + xlab("Year")


par(plt = c(0.2, 0.95, 0.145, 0.883))
stripchart(attendance ~ franchID, data = attd, method = "jitter", pch = 19, las = 1)

ggplot(attd, aes(y = franchID, x = attendance)) + geom_jitter()


## Section 4.2 - Teams in Lahman's Database
# run differential is the difference between runs scored and runs allowed. Rather than use the with statements in section 4.2 

myteams <- teams %>% filter(yearID > 2000) %>% select(teamID, yearID, lgID, G, W, L, R, RA) %>% mutate(RD = R - RA, Wpct = W / (W + L))
tail(myteams)

# Figure 4.1
ggplot(myteams, aes(x = RD, y = Wpct)) + geom_point(cex = 2, alpha = 0.6) + theme_bw() + stat_smooth(method = lm, colour = "black") + xlab("Run differential") + ylab("Winning percentage")

linfit <- lm(Wpct ~ RD, data = myteams)
summary(linfit)
# Wpct = 0.50 + 0.000628*RD

myteams <- myteams %>% mutate(linWpct = predict(linfit), linResiduals = residuals(linfit))
tail(myteams)
min(myteams$linResiduals)
max(myteams$linResiduals)

# Figure 4.2
ggplot(myteams, aes(x = RD, y = linResiduals)) + geom_point(cex = 2) + ylab("Residuals") + xlab("Run differential") + scale_y_continuous(limits = c(-0.09, 0.09)) + scale_x_continuous(limits = c(-400, 400)) + theme_bw()

mean(myteams$linResiduals)
linRMSE <- sqrt(mean(myteams$linResiduals^2))
linRMSE

nrow(subset(myteams, abs(linResiduals) < linRMSE)) / nrow(myteams)
nrow(subset(myteams, abs(linResiduals) < 2 * linRMSE)) / nrow(myteams)

# section 4.4 - the Pythagorean expectation
myteams <- myteams %>% mutate(pytWpct = R^2 / (R^2 + RA^2), pytResiduals = Wpct - pytWpct)
tail(myteams)
sqrt(mean(myteams$pytResiduals^2))

ggplot(myteams, aes(y = pytWpct, x = Wpct)) + geom_point(cex = 2, alpha = 0.6) + theme_bw() + ylab("Pythagorean Win %") + xlab("Win %") + stat_smooth(method = "lm", color = "black")

lm2 <- lm(pytWpct ~ Wpct, data = myteams)
summary(lm2) # 0.034 + 0.93*Wpct

# a function to compare the Bill James Pythagorean model with the linear model. RunsSc = Runs Scored, RunsAll = Runs Allowed, N = exponant
Pythag.line <- function(RunsSc, RunsAll, N){
	linear <- 0.50 + 0.000628 * (RunsSc - RunsAll)
	Pythag <- RunsSc^N / (RunsSc^N + RunsAll^N)
	return(list = c("linear" = linear, "Pythagorean" = Pythag))
}
Pythag.line(1620, 810, N = 2)
Pythag.line(186, 0, N = 2)
Pythag.line(100, 100, N = 2)

# Section 4.5 - the exponent of the Pythagorean formula
myteams <- myteams %>% mutate(logWratio = log(W / L), logRratio = log(R / RA))
tail(myteams)

pytFit <- lm(logWratio ~ logRratio, data = myteams)
summary(pytFit) # suggests a Pythagorean exponent of 1.88 rather than 2.

# Section 4.6 - Good and Bad predictions
games1 <- Pythag.line(875, 737, N = 2)
games1 * 162
games1a <- Pythag.line(875, 757, N = 1.88)
games1a * 162


# Section 4.6 - Good and bad predictions based on the Pythagorean Formula
gl2011 <- read_delim("baseball_R-master/data/gl2011.txt", delim = ",", col_names = FALSE)
head(gl2011) # needs headers
glheaders <- read_csv("baseball_R-master/data/game_log_header.csv")
glheaders
names(gl2011) <- names(glheaders)
head(gl2011)

BOS2011 <- gl2011 %>% filter(HomeTeam == "BOS" | VisitingTeam == "BOS") %>% select(VisitingTeam, HomeTeam, VisitorRunsScored, HomeRunsScore) %>% mutate(ScoreDiff = ifelse(HomeTeam == "BOS", yes = HomeRunsScore - VisitorRunsScored, no = VisitorRunsScored - HomeRunsScore), W = ScoreDiff > 0)
head(BOS2011)
# aggregate(abs(BOS2011$ScoreDiff), list(W = BOS2011$W), summary)

results <- gl2011 %>% select(VisitingTeam, HomeTeam, VisitorRunsScored, HomeRunsScore) %>% mutate(winner = ifelse(HomeRunsScore > VisitorRunsScored, yes = as.character(HomeTeam), no = as.character(VisitingTeam)), diff = abs(VisitorRunsScored - HomeRunsScore))
head(results)

onerungames <- results %>% filter(diff == 1)
dim(onerungames)
head(onerungames)

onerunwins <- onerungames %>% group_by(winner) %>% tally()
names(onerunwins) <- c("teamID", "onerunW")
onerunwins

teams2011 <- myteams %>% filter(yearID == 2011)
teams2011[teams2011$teamID == "LAA", "teamID"] <- "ANA"
teams2011 <- merge(teams2011, onerunwins)
head(teams2011)

# Figure 4.3
ggplot(teams2011, aes(x = onerunW, y = pytResiduals)) + geom_point(cex = 2) + theme_bw() + xlab("One run wins") + ylab("Pythagorean residuals")

pit <- read_csv("baseball_R-master/data/pitching.csv", col_names = TRUE)
head(pit)

top_closers <- pit %>% filter(GF > 50, ERA < 2.5) %>% select(playerID, yearID, teamID)
head(top_closers)
teams_top_closers <- merge(myteams, top_closers)
summary(teams_top_closers$pytResiduals)
mean(teams_top_closers$pytResiduals) * 162 # teams with a top closer will outperform their Pythagorean expectation by 0.8 games


# Section 4.7 -  How many runs for a win?
IR <- function(RS, RA){IRtable <- expand
	round((RS^2 + RA^2)^2 / (2 * RS * RA^2), 1)
}
IRtable <- expand.grid(RS = seq(3, 6, 0.5), RA = seq(3, 6, 0.5))
dim(IRtable)
rbind(head(IRtable), tail(IRtable))
IRtable <- IRtable %>% mutate(IRW = IR(RS, RA))
head(IRtable)

xtabs(IRW ~ RS + RA, data = IRtable)


#####
##### Chapter 5 - Runs Expectancy matrix
#####
### Section 5.2 - Runs scored in the remainder of the inning
# I get a parsing failure when I use read_csv
data2011 <- read.csv("baseball_R-master/data/all2011.csv", header = FALSE)
fields <- read.csv("baseball_R-master/data/fields.csv")
names(data2011) <- fields[, "Header"]
head(data2011)
dim(data2011)

data2011 <- data2011 %>% mutate(RUNS = AWAY_SCORE_CT + HOME_SCORE_CT, HALF.INNING = paste(GAME_ID, INN_CT, BAT_HOME_ID), RUNS.SCORED = ((BAT_DEST_ID > 3) + (RUN1_DEST_ID > 3) + (RUN2_DEST_ID > 3) + (RUN3_DEST_ID > 3))) # Please note, I am following the book here and creating the HALF.INNING variable that contains 3 seperate pieces of data in one cell. This is not tidy, not tidy at all.
head(data2011)

RUNS.SCORED.INNING <- aggregate(data2011$RUNS.SCORED, list(HALF.INNING = data2011$HALF.INNING), sum)
head(RUNS.SCORED.INNING)
 
RUNS.SCORED.START <- aggregate(data2011$RUNS, list(HALF.INNING = data2011$HALF.INNING), "[", 1)
head(RUNS.SCORED.START)

MAX <- data.frame(HALF.INNING = RUNS.SCORED.START$HALF.INNING)
MAX <- MAX %>% mutate(x = RUNS.SCORED.INNING$x + RUNS.SCORED.START$x)
head(MAX)
data2011 <- merge(data2011, MAX)
N <- ncol(data2011)
names(data2011)[N] <- "MAX.RUNS"
data2011 <- data2011 %>% mutate(RUNS.ROI = MAX.RUNS - RUNS)
head(data2011)

### Section 5.3 Creating the matrix
RUNNER1 <- ifelse(as.character(data2011[, "BASE1_RUN_ID"]) == "", 0, 1)
RUNNER2 <- ifelse(as.character(data2011[, "BASE2_RUN_ID"]) == "", 0, 1)
RUNNER3 <- ifelse(as.character(data2011[, "BASE3_RUN_ID"]) == "", 0, 1)

get.state <- function(runner1, runner2, runner3, outs){
	runners <- paste(runner1, runner2, runner3, sep = "")
	paste(runners, outs)
}

data2011 <- data2011 %>% mutate(STATE = get.state(RUNNER1, RUNNER2, RUNNER3, OUTS_CT))
head(data2011)
head(data2011$STATE)

# Create vectors with 0's and 1's.
NRUNNER1 <- with(data2011, as.numeric(RUN1_DEST_ID == 1 | BAT_DEST_ID == 1))
NRUNNER2 <- with(data2011, as.numeric(RUN1_DEST_ID == 2 | RUN2_DEST_ID == 2 | BAT_DEST_ID == 2))
NRUNNER3 <- with(data2011, as.numeric(RUN1_DEST_ID == 3 | RUN2_DEST_ID == 3 | RUN3_DEST_ID == 3 | BAT_DEST_ID == 3))
NOUTS <- with(data2011, OUTS_CT + EVENT_OUTS_CT)

data2011$NEW.STATE <- get.state(NRUNNER1, NRUNNER2, NRUNNER3, NOUTS)
head(data2011)

data2011 <- data2011 %>% filter((STATE != NEW.STATE) | (RUNS.SCORED > 0))
head(data2011)
dim(data2011)

data.outs <- data2011 %>% group_by(HALF.INNING) %>% summarize(Outs.Inning = sum(EVENT_OUTS_CT))
head(data.outs)

data2011 <- inner_join(data2011, data.outs)
head(data2011)
dim(data2011)
data2011C <- data2011 %>% filter(Outs.Inning == 3)
dim(data2011C)

RUNS <- with(data2011C, aggregate(RUNS.ROI, list(STATE), mean))
RUNS$Outs <- substr(RUNS$Group, 5, 5)
RUNS <- RUNS[order(RUNS$Outs), ]
head(RUNS)

RUNS.out <- matrix(round(RUNS$x, 2), 8, 3)
dimnames(RUNS.out)[[2]] <- c("0 outs", "1 out", "2 outs")
dimnames(RUNS.out)[[1]] <- c("000", "001", "010", "011", "100", "101", "110", "111")
RUNS.out

RUNS.2002 <- matrix(c(0.51, 1.40, 1.14, 1.96, .90, 1.84, 1.51, 2.33, 0.27, 0.94, 0.68, 1.36, 0.54, 1.18, 0.94, 1.51, 0.10, 0.36, 0.32, 0.63, 0.23, 0.52, 0.45, 0.78), 8, 3)
dimnames(RUNS.2002) <- dimnames(RUNS.out)
cbind(RUNS.out, RUNS.2002)
# It would be interesting to compare the averages to the Dodgers


### Section 5.4 Measuring success of a batting play
RUNS.POTENTIAL <- matrix(c(RUNS$x, rep(0, 8)), 32, 1)
dimnames(RUNS.POTENTIAL)[[1]] <- c(RUNS$Group, "000 3", "001 3", "010 3", "011 3", "100 3", "101 3", "110 3", "111 3")
data2011$RUNS.STATE <- RUNS.POTENTIAL[data2011$STATE, ]
data2011$RUNS.NEW.STATE <- RUNS.POTENTIAL[data2011$NEW.STATE, ]
data2011 <- data2011 %>% mutate(RUNS.VALUE = RUNS.NEW.STATE - RUNS.STATE + RUNS.SCORED)
head(data2011)

### Section 5.5
Roster <- read_csv("baseball_R-master/data/roster2011.csv", col_names = TRUE)

albert.id <- Roster %>% filter(First.Name == "Albert" & Last.Name == "Pujols") %>% select(Player.ID)
albert.id <- as.character(albert.id[[1]])

albert <- data2011 %>% filter(BAT_ID == albert.id)
head(albert)
dim(albert)

albert %>% select(STATE, NEW.STATE, RUNS.VALUE) %>% slice(1:2) 

albert$RUNNERS <- substr(albert$STATE, 1, 3)
table(albert$RUNNERS)

## Figure 5.1
with(albert, stripchart(RUNS.VALUE ~ RUNNERS, vertical = TRUE, jitter = 0.2, xlab = "RUNNERS", method = "jitter", ylab = "RUNS.VALUE", pch = 19, cex = 0.8, col = rgb(0, 0, 0, 0.5), las = 1))
abline(h = 0, lty = 2, lwd = 2)

A.runs <- aggregate(albert$RUNS.VALUE, list(albert$RUNNERS), sum)
names(A.runs)[2] <- "RUNS"
A.PA <- aggregate(albert$RUNS.VALUE, list(albert$RUNNERS), length)
names(A.PA)[2] <- "PA"
A <- merge(A.PA, A.runs)
A
sum(A$RUNS)

data2011b <- data2011 %>% filter(BAT_EVENT_FL == TRUE)
dim(data2011b)

### Section 5.6 Opportunities and success for all hitters
# Rather than use aggretate, I'll continue to use the dplyr pipeline.
runs.sums <- data2011b %>% select(Batter = BAT_ID, RUNS.VALUE) %>% group_by(Batter) %>% summarize(Runs = sum(RUNS.VALUE))
head(runs.sums); str(runs.sums)

runs.pa <- data2011b %>% select(Batter = BAT_ID, RUNS.VALUE) %>% group_by(Batter) %>% summarize(PA = length(RUNS.VALUE))
head(runs.pa) ;str(runs.pa)

runs.start <- data2011b %>% select(Batter = BAT_ID, RUNS.STATE) %>% group_by(Batter) %>% summarize(Runs.Start = sum(RUNS.STATE))
head(runs.start); str(runs.start)

roster2011 <- read_csv("baseball_R-master/data/roster2011.csv", col_names = TRUE)
head(roster2011)

runs <- inner_join(runs.sums, runs.pa, by = "Batter")
runs <- inner_join(runs, runs.start, by = "Batter")
runs <- inner_join(x = runs, y = roster2011, by = c("Batter" = "Player.ID"))
head(runs)

runs400 <- runs %>% filter(PA >= 400)
head(runs400)

## Figure 5.2
runs.plot <- ggplot(runs400, aes(y = Runs, x = Runs.Start)) + geom_hline(yintercept = 0) + theme_bw() + geom_point(size = 2) + stat_smooth(method = "loess", col = "black", se = FALSE)


# I don't know how to add the top player labels to this plot

runs.plot + geom_text(data = (runs %>% filter(PA >= 400 & Runs >= 40)), aes(PA, Runs, label = Last.Name), check_overlap = FALSE)
# need to get the names to move over


runs400.top <- runs400 %>% filter(Runs >= 40)
head(runs400.top)

runs400.top <-  inner_join(x = runs400.top, y = roster2011, by = c("Batter" = "Player.ID"))
runs400.top

### Section 5.7 Position in batting lineup
get.batting.pos <- function(batter){
	TB <- table(subset(data2011, BAT_ID == batter)$BAT_LINEUP_ID)
	names(TB)[TB == max(TB)][1]
}
position <- sapply(as.character(runs400$Batter), get.batting.pos)
head(position)

## Figure 5.3
ggplot(runs400, aes(x = Runs.Start, y = Runs)) + theme_bw() + stat_smooth(method = "loess", col = "black", se = FALSE) + geom_hline(yintercept = 0) + geom_text(aes(label = position))

### Section 5.8 Runs values of different base hits
d.homerun <- data2011 %>% filter(EVENT_CD == 23)
dim(d.homerun)
table(d.homerun$STATE)

# Make a proportion table
round(prop.table(table(d.homerun$STATE)), 3)

## Figure 5.4
MASS::truehist(d.homerun$RUNS.VALUE, col = "grey", xlim = c(1, 4), las = 1, xlab = "Runs Value, Home Run", ylab = "Density")
abline(v = mean(d.homerun$RUNS.VALUE), lwd = 3)
text(x = 1.5, y = 5, "Mean Runs Value", pos = 4)
# I don't know of a way to make this easily with ggplot2

subset(d.homerun, RUNS.VALUE == max(RUNS.VALUE))[1, c("STATE", "NEW.STATE", "RUNS.VALUE")] 

(mean.HR <- mean(d.homerun$RUNS.VALUE))

d.single <- data2011 %>% filter(EVENT_CD == 20)

## Figure 5.5
MASS::truehist(d.single$RUNS.VALUE, col = "grey", xlim = c(-1, 3), las = 1, xlab = "Runs Value, Single", ylab = "Density")
abline(v = mean(d.single$RUNS.VALUE), lwd = 3)
text(0.5, 5, "Mean Runs Value", pos = 4)
mean(d.single$RUNS.VALUE)

table(d.single)
round(prop.table(table(d.single$STATE)), 3)

subset(d.single, d.single$RUNS.VALUE == min(d.single$RUNS.VALUE))[, c("STATE", "NEW.STATE", "RUNS.VALUE")]

### Section 5. 9 value of stolen bases
stealing <- data2011 %>% filter(EVENT_CD == 6| EVENT_CD == 4)
dim(stealing)
head(stealing)

table(stealing$EVENT_CD)
table(stealing$STATE)

## Figure 5.6
MASS::truehist(stealing$RUNS.VALUE, xlim = c(-1.5, 1.5), col = "grey", xlab = "Runs Value, Stealing", las = 1, ylab = "Density")
abline(v = mean(stealing$RUNS.VALUE), lwd = 3)
mean(stealing$RUNS.VALUE)

stealing.1001 <- stealing %>% filter(STATE == "100 1")
table(stealing.1001$EVENT_CD)
with(stealing.1001, table(NEW.STATE))
mean(stealing.1001$RUNS.VALUE)

#####
##### Chapter 6 - Advanced graphics
#####

### Section 6.2 - the lattice package. I think the power of the lattice package comes from the facets (multi-pane images). We can use the facet() function in ggplot2 to the same effect.

# The Verlander dataset
load("baseball_R-master/data/balls_strikes_count.RData")
str(verlander)
dim(verlander)

sampleRows <- verlander %>% sample_n(20, replace = FALSE) # Note that the sample function in R has replace = FALSE as the default as well. 
sampleRows

## Figure 6.1
ggplot(verlander, aes(speed)) + theme_bw() + geom_histogram() + xlab("Speed") + ylab("Count")

ggplot(verlander, aes(speed)) + theme_bw() + geom_line(stat = "density") + ylab("Density") + xlab("Speed")

## Figure 6.2
ggplot(verlander, aes(speed)) + theme_bw() + geom_line(stat = "density") + ylab("Density") + xlab("Speed") + facet_wrap(~ pitch_type, nrow = 5)

## Figure 6.3
ggplot(verlander, aes(speed, lty = pitch_type)) + theme_bw() + geom_line(stat = "density") + ylab("Density") + xlab("Speed")

## Figure 6.4
F4verl <- verlander %>% filter(pitch_type == "FF") %>% mutate(gameDay = as.integer(format(gamedate, format = "%j")))
head(F4verl)
dim(F4verl)

# Using dplyr rather than aggregate
dailySpeed <- F4verl %>% select(gameDay, season, speed) %>% group_by(gameDay, season) %>% summarize(speed = mean(speed))
dim(ds)
head(ds)

ggplot(dailySpeed, aes(y = speed, x = gameDay)) + theme_bw() + facet_wrap(~ season, nrow = 2) + geom_point(size = 2) + ylab("Pitch Speed (MPH)") + xlab("Day of Year")

## Figure 6.5
speedFC <- verlander %>% filter(pitch_type %in% c("FF", "CH"))
head(speedFC)

avgspeedFC <- speedFC %>% select(pitch_type, season, speed) %>% group_by(season, pitch_type) %>% summarize(speed = mean(speed))
avgspeedFC

ggplot(avgspeedFC, aes(y = season, x = speed)) + theme_bw() + geom_text(aes(label = pitch_type)) + ylab("Season") + xlab("Speed")

## Figure 6.6
avgSpeed <- F4verl %>% select(pitches, season, speed) %>% group_by(pitches, season) %>% summarize(speed = mean(speed))
head(avgSpeed)

ggplot(avgSpeed, aes(y = speed, x = pitches)) + theme_bw() + facet_wrap(~ season, nrow = 2) + geom_point(size = 1.5) + geom_hline(aes(yintercept = mean(speed))) 

## Figure 6.7
NoHit <- verlander %>% filter(gamedate == "2011-05-07")
dim(NoHit)
head(NoHit)

f6.7 <- ggplot(NoHit, aes(x = px, y = pz)) + theme_bw() + facet_wrap(~ batter_hand, nrow = 1) + geom_point(aes(shape = pitch_type), size = 2.5)
f6.7

### Figure 6.8
f6.8 <- ggplot(NoHit, aes(x = px, y = pz)) + theme_bw() + facet_wrap(~ batter_hand, ncol = 1) + geom_point(aes(shape = pitch_type), size = 2.5) + xlim(-2.2, 2.2) + ylim(0, 4)
f6.8

### Figure 6.9
f6.9 <- ggplot(NoHit, aes(x = px, y = pz)) + theme_bw() + facet_wrap(~ batter_hand, nrow = 1) + geom_point(aes(shape = pitch_type), size = 2.5) + xlim(-2.2, 2.2) + ylim(0, 5) + ylab("Vertical Location\n(ft. from ground)") + xlab("Horizontal Location\n(ft. from middle of plate)") + labs(shape = "Pitch Type")
f6.9

### Figure 6.10
topKzone <- 3.5
botKzone <- 1.6
inKzone <- -0.95
outKzone <- 0.95

f6.10 <- ggplot(NoHit, aes(x = px, y = pz)) + theme_bw() + facet_wrap(~ batter_hand, nrow = 1) + geom_point(aes(shape = pitch_type), size = 2.5) + xlim(-2.2, 2.2) + ylim(0, 5) + ylab("Vertical Location\n(ft. from ground)") + xlab("Horizontal Location\n(ft. from middle of plate)") + labs(shape = "Pitch Type") + annotate("rect", xmin = -0.95, xmax = 0.95, ymin = 1.6, ymax = 3.5, fill = "dodgerblue", alpha = 0.3) # I think that shading in the strike zone is WAY prettier than a dashed line box. 
f6.10

### Figure 6.11
head(cabrera)
dim(cabrera)

ggplot(cabrera, aes(x = hitx, y = hity)) + geom_point()

### Figure 6.12
ggplot(cabrera, aes(x = hitx, y = hity)) + geom_point(aes(color = hit_outcome)) + coord_equal()

### Figure 6.13
ggplot(cabrera, aes(x = hitx, y = hity)) + geom_point(aes(color = hit_outcome)) + coord_equal() + facet_wrap(~ season)

bases <- data.frame(x = c(0, 90 / sqrt(2), 0, -90 / sqrt(2), 0), y = c(0, 90 / sqrt(2), 2 * 90 / sqrt(2), 90 / sqrt(2), 0))

### Figure 6.14
ggplot(cabrera, aes(x = hitx, y = hity)) + geom_point(aes(color = hit_outcome)) + coord_equal() + facet_wrap(~ season) + geom_path(aes(x = x, y = y), data = bases) + geom_segment(x = 0, xend = 300, y = 0, yend = 300) + geom_segment(x = 0, xend = -300, y = 0, yend = 300)

### Figure 6.15
cabreraStretch <- cabrera %>% filter(gamedate > "2012-08-31")
ggplot(cabreraStretch, aes(x = hitx, y = hity)) + geom_point(aes(shape = hit_outcome, color = pitch_type, size = speed)) + coord_equal() + geom_path(aes(x = x, y = y), data = bases) + guides(col = guide_legend(ncol = 2))+ geom_segment(x = 0, xend = 300, y = 0, yend = 300) + geom_segment(x = 0, xend = -300, y = 0, yend = 300)

### Figure 6.16 Note that recent ggplot2 versions use geom_hline 
ggplot(F4verl, aes(x = pitches, y = speed)) + facet_wrap(~ season) + geom_hline(aes(yintercept = mean(speed)), lty = 3) + geom_point(aes(x = pitches, y = speed), data = F4verl[sample(1:nrow(F4verl), 1000), ]) + geom_smooth(col = "black") + geom_vline(aes(xintercept = 100), col = "black", lty = 2)

### Figure 6.17
kZone <- data.frame(x = c(inKzone, inKzone, outKzone, outKzone, inKzone), y = c(botKzone, topKzone, topKzone, botKzone, botKzone))
kZone

# In my experience, setting the facet prior to calling geom is good practice
ggplot(F4verl, aes(x = px, y = pz)) + facet_wrap(~ batter_hand) + geom_point() + coord_equal() + geom_path(aes(x, y), data = kZone, lwd = 2, col = "white")

### Figure 6.18
ggplot(F4verl, aes(x = px, y = pz)) + facet_wrap(~ batter_hand) + stat_binhex() + coord_equal() + geom_path(aes(x, y), data = kZone, lwd = 2, col = "white", alpha = 0.3)

### Figure 6.19
Comerica <- jpeg::readJPEG("baseball_R-master/data/Comerica.jpg")

ggplot(cabrera, aes(x = hitx, y = hity)) + coord_equal() + annotation_raster(Comerica, -310, 305, -100, 480) + stat_binhex(alpha = 0.9, binwidth = c(5, 5)) + scale_fill_gradient(low = "grey70", high = "black")

#####
##### Chapter 7 - Ball and strike effects
#####

### Figure 7.1 - This is essentially a plot of a contingency table
mussina <- expand.grid(balls = 0:3, strikes = 0:2)
mussina$value <- c(100, 118, 157, 207, 72, 82, 114, 171, 30, 38, 64, 122)
mussina

library("plotrix")

countmap <- function(data){data <- xtabs(value ~ ., data)color2D.matplot(data, show.values = 2, axes = FALSE, xlab = "", ylab = "")axis(side = 2, at = 3.5:0.5, labels = rownames(data), las = 1)axis(side = 3, at = 0.5:2.5, labels = colnames(data))mtext(text = "Balls", side = 2, line = 2, cex.lab = 1)mtext(text = "Strikes", side = 3, line = 2, cex.lab = 1)}
countmap(mussina)

## Functions for string manipulation
sequences <- c("BBX", "C11BBC1S", "1X")
grep("1", sequences)
grepl("1", sequences)
grepl("11", sequences)
gsub("1", "", sequences)

pbp2011 <- read_csv("baseball_R-master/data/all2011.csv", col_names = FALSE)
headers <- read_csv("baseball_R-master/data/fields.csv")
names(pbp2011) <- headers$Header
head(pbp2011)
dim(pbp2011)

pbp2011 <- pbp2011 %>% mutate(pseq = gsub("[.>123N+*]", "", PITCH_SEQ_TX), c10 = grepl("^[BIPV]", pseq), c01 = grepl("^[CFKLMOQRST]", pseq))
pbp2011[1:10, c("PITCH_SEQ_TX", "c10", "c01")]

## Expect run value by count
pbp11rc <- read.csv("baseball_R-master/data/pbp11rc.csv", header = TRUE) # using read_csv results in 198 parsing errors
pbp11rc[1:5, c("GAME_ID", "EVENT_ID", "c00", "c10", "c20", "c11", "c01", "c30", "c21", "c31", "c02", "c12", "c22", "c32", "RUNS.VALUE")]

ab10 <- pbp11rc %>% filter(c10 == 1)
ab01 <- pbp11rc %>% filter(c01 == 1)
c(mean(ab10$RUNS.VALUE), mean(ab01$RUNS.VALUE))

runs.by.count <- expand.grid(balls = 0:3, strikes = 0:2)
runs.by.count$value <- 0

bs.count.run.value <- function(b, s){
	column.name <- paste("c", b, s, sep = "")
	mean(pbp11rc[pbp11rc[, column.name] == 1, "RUNS.VALUE"])
}

runs.by.count$value <- mapply(FUN = bs.count.run.value, 
	b = runs.by.count$balls,
	s = runs.by.count$strikes)

### Figure 7.2
countmap(runs.by.count)

count22 <- pbp11rc %>% filter(c22 == 1)
mean(count22$RUNS.VALUE) # This was also in figure 7.2

count22 <- count22 %>% mutate(after2 = ifelse(c20 == 1, "2-0", ifelse(c02 == 1, "0-2", "1-1")))
head(count22)

# Using dplyr pipes rather than aggregate, because they are more intuitive to me.  
count22 %>% group_by(after2) %>% summarize(RUNS.VALUE = mean(RUNS.VALUE)) # Note the excellent point made by the authors about this seemingly odd result. 

count11 <- pbp11rc %>% filter(c11 == 1) %>% mutate(after1 = ifelse(c10 == 1, "1-0", "0-1"))
count11 %>% group_by(after1) %>% summarize(RUNS.VALUE = mean(RUNS.VALUE))

### Figure 7.3
load("baseball_R-master/data/balls_strikes_count.Rdata")

sampCabrera <- cabrera %>% sample_n(500, replace = FALSE)
str(sampCabrera$swung) #swung is an integer but should be a factor
sampCabrera$swung <- as.factor(sampCabrera$swung)

ggplot(sampCabrera, aes(x = px, y = pz, shape = swung)) + theme_bw() + geom_point(size = 3) + xlim(-3, 3) + ylim(-0, 5) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location(ft.)") + annotate("rect", xmin = -0.95, xmax = 0.95, ymin = 1.6, ymax = 3.5, fill = "dodgerblue", alpha = 0.3) # I think that shading in the strike zone is WAY prettier than a dashed line box. 

miggy.loess <- loess(swung ~ px + pz, data = cabrera, control = loess.control(surface = "direct"))
pred.area <- expand.grid(px = seq(-2, 2, 0.1), pz = seq(0, 6, 0.1))
pred.area$fit <- c(predict(miggy.loess, pred.area))

pred.area %>% filter(px == 0 & pz == 2.5)
pred.area %>% filter(px == 0 & pz == 0)
pred.area %>% filter(px == 2 & pz == 2.5)

### Figure 7.4 - contour plot - I don't know how to make the countourplot exactly as it is from the lattice package
ggplot(cabrera, aes(x = px, y = pz)) + theme_bw() + ylim(0.5, 4.5) + xlim(-1.5, 1.5) + stat_density2d(aes(color = ..level..), n = 100, h = c(2, 2)) + annotate("rect", xmin = -0.95, xmax = 0.95, ymin = 1.6, ymax = 3.5, fill = "dodgerblue", alpha = 0.3)

cabrera <- cabrera %>% mutate(bscount = paste(balls, strikes, sep = "-"))
head(cabrera)

# I don't see how to do this section following the tidy principle. Lots of small steps. Need to think on it. 
miggy00 <- cabrera %>% filter(bscount == "0-0")
miggy00loess <- loess(swung ~ px + pz, data = miggy00, control = loess.control(surface = "direct"))

pred.area$fit00 <- c(predict(miggy00loess, pred.area))
head(pred.area)


table(verlander$pitch_type)
round(100 * prop.table(table(verlander$pitch_type)))

# type_verlander_hand <- verlander %>% select(batter_hand, pitch_type) %>% group_by(batter_hand, pitch_type) %>% table(pitch_type, batter_hand)

type_verlander_hand <- with(verlander, table(pitch_type, batter_hand))
round(100 * prop.table(type_verlander_hand, margin = 2))


verlander <- verlander %>% mutate(bscount = paste(balls, strikes, sep = "-"))
head(verlander)
verl_RHB <- verlander %>% filter(batter_hand == "R")
head(verl_RHB)
verl_type_cnt_R <- table(verl_RHB$bscount, verl_RHB$pitch_type)
round(100 * prop.table(verl_type_cnt_R, margin = 1))

# This needs to be made into a function
umpiresRHB <- umpires %>% filter(batter_hand == "R")
head(umpiresRHB)


ump_func <- function(int1, int2, data){
	ump_temp <- filter(data, balls == int1 & strikes == int2)
	ump_smp <- ump_temp %>% sample_n(3000, replace = FALSE)
	return(ump_smp)
}

ump_00 <- ump_func(int1 = 0, int2 = 0, data = umpiresRHB)
dim(ump_00)
head(ump_00)

ump_30 <- ump_func(int1 = 3, int2 = 0, data = umpiresRHB)
head(ump_30)
dim(ump_30)

ump_02 <- ump_func(int1 = 0, int2 = 2, data = umpiresRHB)
dim(ump_02)
head(ump_02)


ump_loess <- function(data){
	ump.loess <- loess(called_strike ~ px + pz, data = data, control = loess.control(surface = "direct"))
	return(ump.loess)
}

ump00.loess <- ump_loess(data = ump_00)
ump30.loess <- ump_loess(data = ump_30)
ump02.loess <- ump_loess(data = ump_02)

ump_contours <- function(data){
	ump_tours <- contourLines(x = seq(-2, 2, 0.1), y = seq(0, 6, 0.1), z = predict(data, pred.area), levels = c(0.5))
	return(ump_tours)
}

ump00contour <- ump_contours(data = ump00.loess)
ump30contour <- ump_contours(data = ump30.loess)
ump02contour <- ump_contours(data = ump02.loess)


ump00df <- as.data.frame(ump30contour)
ump00df$bscount <- "0-0"
head(ump00df)

ump30df <- as.data.frame(ump30contour)
ump30df$bscount <- "3-0"
head(ump30df)

ump02df <- as.data.frame(ump02contour)
ump02df$bscount <- "0-2"
head(ump02df)

umpireContours <- rbind(ump00df, ump02df, ump30df)

# Work on this some more
ggplot(umpireContours, aes(x = x, y = y)) + theme_bw() + stat_density2d(aes(color = bscount))


#####
##### Chapter 8 - career trajectories
#####

Batting <- read.csv("2016_core/core/Batting.csv", header = TRUE)
head(Batting) # using read.csv here rather than read_csv because it imports triples as X3B rather than 3B, which is not the best
# I don't know how to recode variables with dplyr
Batting$SF <- car::recode(Batting$SF, "NA = 0")
Batting$HBP <- car::recode(Batting$HBP, "NA = 0")
head(Batting)
dim(Batting)

# calculate rolling mean for BA by 5 year chunk

Deanna <- Batting %>% group_by(playerID) %>% mutate(BA = (H / AB))
head(Deanna)
dim(Deanna)

mantleBA <- Deanna %>% filter(playerID == "mantlmi01")
dim(mantleBA)

Troi <- zoo::rollmean(mantleBA$BA, k = 5)

head(Deanna %>% group_by(Year))
head(Troi)
summary(Troi)


Master <- read_csv("2016_core/core/Master.csv", col_names = TRUE)
head(Master)

mantle.id <- Master %>% filter(nameFirst == "Mickey" & nameLast == "Mantle") %>% select(playerID)



get.birthyear <- function(player.id){
	playerline <- Master %>% filter(playerID == as.character(player.id))
	birthyear <- playerline$birthYear
	birthmonth <- playerline$birthMonth
	ifelse(birthmonth >= 7, birthyear + 1, birthyear)
}
get.birthyear(mantle.id)

# Note that the book formula for OBP does not include HBP, which is part of the formula. Further, the book inculdes hits in the denominator. 
get.stats <- function(player.id){
	d <- Batting %>% filter(playerID == as.character(player.id))
	byear <- get.birthyear(as.character(player.id))
	d <- d %>% mutate(Age = yearID - byear, SLG = (((H - X2B - X3B - HR) + (2 * X2B) + (3 * X3B) + (4 * HR)) / AB), OBP = ((H + BB + HBP) / (AB + BB + SF + HBP)), OPS = SLG + OBP)
	d
}

Mantle <- get.stats(mantle.id)
Mantle

## Figure 8.1
ggplot(Mantle, aes(x = Age, y = OPS)) + theme_bw() + geom_point(size = 2)

fit.model <- function(d){
	fit <- lm(OPS ~ I(Age - 30) + I((Age - 30)^2), data = d)
	b <- coef(fit)
	Age.max <- 30 - b[2] / b[3] / 2
	Max <- b[1] - b[2]^2 / b[3] / 4
	list(fit = fit, Age.max = Age.max, Max = Max)
}

F2 <- fit.model(Mantle)
F2


# In honor of ARod
Arod.id <- Master %>% filter(nameFirst == "Alex" & nameLast == "Rodriguez") %>% select(playerID)
get.birthyear(Arod.id)
Arod <- get.stats(Arod.id) #only through 2015
A2 <- fit.model(Arod)
A2 # Arod peaked at 28 for OPS but stayed OK
# ggplot(Arod, aes(x = Age, y = OPS)) + theme_bw() + geom_point(size = 2) 
plot(x = Arod$Age, y = Arod$OPS, las = 1, pch = 19, cex =1.5, ylab = "OPS", xlab = "Age", xlim = c(17, 40), ylim = c(0, 1.1))
lines(Arod$Age, predict(A2$fit, Age = Arod$Age), lwd = 3, lty = 2)
#


#### Section 8.3
Fielding <- read_csv("2016_core/core/Fielding.csv", col_names = TRUE)
head(Fielding)

AB.totals <- Batting %>% group_by(playerID) %>% summarize(Career.AB = sum(AB, na.rm = TRUE))
head(AB.totals)

Batting <- full_join(Batting, AB.totals, by = "playerID")
head(Batting)
Batting.2000 <- Batting %>% filter(Career.AB >= 2000)
head(Batting.2000)
dim(Batting.2000)

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

Fielding.2000 <- data.frame(playerID = names(POSITIONS), POS = POSITIONS)
head(Fielding.2000)
Batting.2000 <- left_join(Batting.2000, Fielding.2000, by = "playerID") # Becuase there are duplicate column names they get suffixes. The only way I know how to remove these is clunky.

# Batting.2000 <- merge(Batting.2000, Fielding.2000)
head(Batting.2000)
dim(Batting.2000)


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
	C.SB = sum(SB, na.rm = TRUE)) %>% mutate(C.AVG = (C.H / C.AB), 	C.SLG = (((C.H - C.2B - C.3B - C.HR) + (2 * C.2B) + (3 * C.3B) + (4 * C.HR)) / C.AB))
head(C.totals)

C.totals <- inner_join(C.totals, Fielding.2000, by = "playerID")
head(C.totals) 

C.totals$Value.POS <- with(C.totals,
	ifelse(POS == "C", 240,	ifelse(POS == "SS", 168,	ifelse(POS == "2B", 132,	ifelse(POS == "3B", 84,	ifelse(POS == "OF", 48,	ifelse(POS == "1B", 12, 0)))))))
	
head(C.totals)	

similar <- function(p, number = 10){	P <- subset(C.totals, playerID == p)	C.totals$SS <- with(C.totals,	1000 -	floor(abs(C.G - P$C.G) / 20) -	floor(abs(C.AB - P$C.AB) / 75) -	floor(abs(C.R - P$C.R) / 10) -	floor(abs(C.H - P$C.H) / 15) -	floor(abs(C.2B - P$C.2B) / 5) -	floor(abs(C.3B - P$C.3B) / 4) -	floor(abs(C.HR - P$C.HR) / 2) -	floor(abs(C.RBI - P$C.RBI) / 10) -	floor(abs(C.BB - P$C.BB) / 25) -	floor(abs(C.SO - P$C.SO) / 150) -	floor(abs(C.SB - P$C.SB) / 20) -	floor(abs(C.AVG - P$C.AVG) / 0.001) -	floor(abs(C.SLG - P$C.SLG) / 0.002) -	abs(Value.POS - P$Value.POS))C.totals <- C.totals[order(C.totals$SS, decreasing = TRUE), ]C.totals[1:number, ]}

similar(as.character(mantle.id), 6) # This is nice and all but I bet that hierarchical cluster analysis could do a great job at this. 

collapse.stint <- function(d){G <- sum(d$G)
AB <- sum(d$AB)
R <- sum(d$R)H <- sum(d$H) 
X2B <- sum(d$X2B)
X3B <- sum(d$X3B)HR <- sum(d$HR)
RBI <- sum(d$RBI) 
SB <- sum(d$SB)CS <- sum(d$CS) 
BB <- sum(d$BB) 
SH <- sum(d$SH)SF <- sum(d$SF)
HBP <- sum(d$HBP)SLG <- ((H - X2B - X3B - HR + 2 * X2B +3 * X3B + 4 * HR) / AB)OBP <- ((H + BB + HBP) / (AB + BB + HBP + SF)) # This is the correct OBP formula. Earlier it is incorrect. OPS <- SLG + OBPdata.frame(G = G, AB = AB, R = R, H = H, X2B = X2B, X3B = X3B, HR = HR, RBI = RBI, SB = SB, CS = CS, BB = BB, HBP = HBP, SH = SH, SF = SF, SLG = SLG, OBP = OBP, OPS = OPS, Career.AB = d$Career.AB[1], POS = d$POS[1])
}

stuff <- function(d){
	d %>% group_by(playerID, yearID) %>% summarize(G = sum(G), AB = sum(AB), R = sum(R), H = sum(H), X2B = sum(X2B), X3B = sum(X3B), HR = sum(HR), RBI = sum(RBI), SB = sum(SB), CS = sum(CS), BB = sum(BB), SH = sum(SH), SF = sum(SF), HBP = sum(HBP), SLG = (((H - X2B - X3B - HR) + (2 * X2B) + (3 * X3B) + 4 * HR) / AB), OBP = ((H + BB + HBP) / (AB + BB + HBP + SF)), OPS = SLG + OBP, Career.AB = Career.AB[1], POS = POS[1]) # This is the correct OBP formula. Earlier it is incorrect.

}

B2K <- collapse.stint(Batting.2000)

#B2k <- stuff(Batting.2000)

Batting.2000 <- plyr::ddply(Batting.2000, .(playerID, yearID), collapse.stint)

#B2K <- plyr::ddply(.data = Batting.2000,  .variables = c(playerID, yearID), .fun = collapse.stint)

#B2b <- Batting.2000 %>% group_by(playerID) %>% collapse.stint


fit.trajectory <- function(d){
	fit <- lm(OPS ~ I(Age - 30) + I((Age - 30)^2), data = d)
	data.frame(Age = d$Age, Fit = predict(fit, Age = d$Age))
}











# Moving averages of runs per game for the Dodgers

teams <- read_csv("2016_core/core/Teams.csv", col_names = TRUE)
tail(teams)
dim(teams)
LAD <- teams %>% filter(franchID == "LAD")
head(LAD)
dim(LAD)

ggplot(LAD, aes(x = yearID, y = (R / G))) + theme_bw() + geom_point(size = 2) + ylab("Average Runs per Game") + xlab("Year") + ylim(2, 8) + scale_x_continuous(breaks = c(seq(1880, 2015, by = 15))) + stat_smooth(method = "loess", color = "black")


library("openWAR")
gd <- gameday()
summary(gd)
plot(gd)

# ds <- getData() # Defaults to all games yesterday
getGameIds(date = as.Date("2016-08-16"))
gd <- gameday(gameId = "gid_2016_08_16_lanmlb_phimlb_1")
summary(gd)
class(gd)

head(gd$ds)

gd$ds %>% filter(runsOnPlay > 0) %>% select(description)

# compute linescore
gd$ds %>% group_by(inning) %>% summarize(LAD = sum(ifelse(half == "top", runsOnPlay, 0)), PHI = sum(ifelse(half == "bottom", runsOnPlay, 0)))

# Compute final score
gd$ds %>% group_by(half) %>% summarize(PA = sum(isPA), R = sum(runsOnPlay), H = sum(isHit))


library("pitchRx")

data <- scrape(start = "2015-08-26", end = "2015-08-26")