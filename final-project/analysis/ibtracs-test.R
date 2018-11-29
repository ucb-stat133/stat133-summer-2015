


# input file
infile <- '~/Documents/stat133/final_project/rawdata/nabasin.hdat'
lim <- system(sprintf('wc -l %s', infile), intern = TRUE)
max_lines <- as.numeric(str_extract(lim, "\\d+")) + 1

# initializing files storms.csv and tracks.csv
init_storms()
init_tracks()

# line counter
i <- 1

repeat {
  rec <- scan(infile, what = character(), nlines = 1, 
              skip = i-1, sep = '\n', quiet = TRUE)
  
  #if (length(rec) == 0 | i == 50) break
  if (length(rec) == 0 | i == max_lines) break
  
  if (is_header(rec)) {
    # storm header
    header <- parse_header(rec)
    export_line(header, file = 'storms.csv')
    id <- header_storm_num(rec)
    year <- header_storm_year(rec)
    print(paste('storm', id))
  } else if (is_daily(rec)) {
    # daily data
    date <- daily_track_date(rec, year)
    periods <- daily_track_periods(rec)
    daily <- lapply(periods, build_period, id, date)
    # export lines
    lapply(daily, export_track, file = 'tracks.csv')
  } else if (is_trailer(rec)) {
    NULL
  }
  i <- i + 1
}




tracks <- read.csv('~/Documents/tracks.csv')
dim(tracks)
tail(tracks)

tracks$long = -1 * tracks$long

write.csv(tracks, '~/Desktop/tracks.csv', row.names = FALSE)

tracks <- read.csv('~/Desktop/tracks.csv')

library("maps")
map()
points(tracks$long, tracks$lat, pch = '.', col = '#77777722')

points(-1*tracks$long, tracks$lat, pch = '.')


# ==========================================================

library(lubridate)
library(dplyr)
library(FactoMineR)

# pressure > 0
subtracks <- subset(tracks, press > 0)

with(subtracks, hist(wind))
with(subtracks, hist(press))

with(subtracks, 
     plot(press, wind, pch = 19, col = "#35986733"))
with(subtracks, cor(wind, press))

reg <- lm(wind ~ press, data = subtracks)
summary(reg)


wind_mean <- tapply(subtracks$wind, subtracks$id, mean)
wind_sd <- tapply(subtracks$wind, subtracks$id, sd)
wind_min <- tapply(subtracks$wind, subtracks$id, min)
wind_max <- tapply(subtracks$wind, subtracks$id, max)

wind_df <- data.frame(
  mean = wind_mean,
  stdev = wind_sd,
  range = wind_max - wind_min
)


# mean_wind <- tapply(subtracks$lat, subtracks$id, mean)
wind_summary <- tapply(subtracks$wind, subtracks$id, summary)
winds <- do.call('rbind', wind_summary)
dim(winds)

press_summary <- tapply(subtracks$press, subtracks$id, summary)
press <- do.call('rbind', press_summary)
dim(press)

WP <- cbind.data.frame(winds, press)
colnames(WP) <- paste(
  rep(c('w', 'p'), each = 6),
  c('min', 'q1', 'med', 'mean', 'q3', 'max'),
  sep = '_'
  )
head(WP)


with(WP, plot(p_mean, w_mean))

wp_pca <- PCA(WP, graph = FALSE)

plot(wp_pca, choix = 'var')
plot(wp_pca$ind$coord[,1:2])



# cluster analysis
wp_dist <- dist(WP, method = 'euclidean')
wp_clus <- hclust(wp_dist, method = 'ward.D')
plot(wp_clus)

wp_cluster <- cutree(wp_clus, k = 3)
plot(wp_pca$ind$coord[,1:2], 
     col = wp_cluster)

plot(WP$p_mean, WP$w_mean,
     col = wp_cluster, pch = 20)
