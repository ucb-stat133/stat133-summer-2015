
library(lubridate)
library(dplyr)

# ===============================================================
# Data set 'storms'
# ===============================================================

clean_storms <- read.csv('data/storms.csv', 
                         stringsAsFactors = FALSE)

# add column year
clean_storms$year <- as.numeric(substr(clean_storms$date, 7, 10))

# subset storms (years 1980 - 2010)
storms <- subset(clean_storms, year > 1979 & year < 2011)
storms$date <- as.Date(storms$date, format = '%m/%d/%Y')
head(storms)


# ===============================================================
# storms per year
# ===============================================================
# How many storms per year
storms_per_year <- storms %>%
  group_by(year) %>%
  summarise(count = length(year))

# barplot
barplot(storms_per_year$count, names.arg = storms_per_year$year,
        las = 2, border = NA)
title('Storms per year')


# ===============================================================
# storms per month
# ===============================================================
# How many storms per month
storms_per_month <- storms %>%
  group_by(month(date)) %>%
  summarise(count = n())

names(storms_per_month)[1] <- 'month'
storms_per_month$month <- month.name[storms_per_month$month]
storms_per_month

# barplot
barplot(storms_per_month$count, names.arg = storms_per_month$month,
        las = 2, border = NA)
title('Storms per month (all years 1980 - 2010')



# ===============================================================
# Data set 'tracks'
# ===============================================================

clean_tracks <- read.csv('data/tracks.csv', 
                   stringsAsFactors = FALSE)

clean_tracks$year <- as.numeric(substr(clean_tracks$date, 7, 10))

tracks <- subset(clean_tracks, year > 1979 & year < 2011)
head(tracks)


mean_wind <- tracks %>%
  group_by(id) %>%
  summarise(avg_wind = mean(wind))
dim(mean_wind)
head(mean_wind)

summary_wind <- tracks %>%
  group_by(id) %>%
  summarise(mean(wind), sd(wind), max(wind), min(wind))
dim(summary_wind)
head(summary_wind)


# storms 35 knots
tracks_35knots <- tracks %>%
  group_by(id) %>%
  filter(wind >= 35) %>%
  tally()
head(tracks_35knots)

storms_35knots <- table(
  storms$year[storms$id %in% tracks_35knots$id]
)
barplot(storms_35knots, las = 2)
mean(storms_35knots)
sd(storms_35knots)
quantile(storms_35knots, probs = c(0.25, 0.5, 0.75))



# storms 64 knots
tracks_64knots <- tracks %>%
  group_by(id) %>%
  filter(wind >= 64) %>%
  tally()
head(tracks_64knots)

storms_64knots <- table(
  storms$year[storms$id %in% tracks_64knots$id]
)
barplot(storms_64knots, las = 2)
mean(storms_64knots)
sd(storms_64knots)
quantile(storms_64knots, probs = c(0.25, 0.5, 0.75))


# storms 96 knots
tracks_96knots <- tracks %>%
  group_by(id) %>%
  filter(wind >= 96) %>%
  tally()

storms_96knots <- table(
  storms$year[storms$id %in% tracks_96knots$id]
)
barplot(storms_96knots, las = 2)
mean(storms_96knots)
sd(storms_96knots)
quantile(storms_96knots, probs = c(0.25, 0.5, 0.75))


# ===============================================================
# Regression Analysis
# ===============================================================

wind_press <- tracks %>% 
  group_by(id) %>%
  summarise(
    mean_wind = mean(wind),
    mean_press = mean(press),
    median_wind = median(wind),
    median_press = median(press))


mean_press <- tapply(tracks$press, tracks$id, mean)
mean_wind <- tapply(tracks$wind, tracks$id, mean)

median_press <- tapply(tracks$press, tracks$id, median)
median_wind <- tapply(tracks$wind, tracks$id, median)

wind_press <- data.frame(
  mean_press,
  mean_wind,
  median_press,
  median_wind)

with(subset(wind_press, mean_press > 0),
     plot(mean_press, mean_wind))

with(subset(wind_press, median_press > 0),
     plot(median_press, median_wind))

with(subset(wind_press, median_press > 0),
     cor(median_press, median_wind))
