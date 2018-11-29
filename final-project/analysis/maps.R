
# load library maps and ggplot2
library(maps)
library(ggplot2)

# read files (Basins 'NA' and 'EP')
nabasin <- read.csv('rawdata/nabasin.csv', 
                    skip = 1, stringsAsFactors = FALSE)

epbasin <- read.csv('rawdata/epbasin.csv',
                    skip = 1, stringsAsFactors = FALSE)


# remove variable information
nabasin <- nabasin[-1, ]
epbasin <- nabasin[-1, ]

# setting format in NA.basin
nabasin$Season <- as.numeric(nabasin$Season)
nabasin$Latitude <- as.numeric(gsub("^ ", "", nabasin$Latitude))
nabasin$Longitude <- as.numeric(gsub("^ ", "", nabasin$Longitude))
nabasin$Wind.WMO. <- as.numeric(gsub("^ ", "", nabasin$Wind.WMO.))

# setting format in epbasin
epbasin$Season <- as.numeric(epbasin$Season)
epbasin$Latitude <- as.numeric(gsub("^ ", "", epbasin$Latitude))
epbasin$Longitude <- as.numeric(gsub("^ ", "", epbasin$Longitude))
epbasin$Wind.WMO. <- as.numeric(gsub("^ ", "", epbasin$Wind.WMO.))

# extract month nabasin
na_time_date <- strsplit(nabasin$ISO_time, " ")
na_iso_date <- unlist(lapply(na_time_date, function(x) x[1]))
na_iso_month <- substr(na_iso_date, 6, 7)
nabasin$Month <- factor(na_iso_month, labels = c(month.name))

# extract month epbasin
ep_time_date <- strsplit(epbasin$ISO_time, " ")
ep_iso_date <- unlist(lapply(ep_time_date, function(x) x[1]))
ep_iso_month <- substr(ep_iso_date, 6, 7)
epbasin$Month <- factor(iso.month, labels=c(month.name)[-4])



# join data frames
#storms = rbind(nabasin, epbasin)
storms <- nabasin

# world map
world_map <- map_data("world")

# select years 1999-2010
substorms <- subset(storms, Season %in% 1999:2010)

# remove unnamed storms
no_named <- (substorms$Name == "NOT NAMED")
substorms <- substorms[!no_named, ]

# joining name and season
substorms$ID <- as.factor(paste(substorms$Name, substorms$Season, sep="."))

# name as factor
substorms$Name <- as.factor(substorms$Name)

# plot map 1 (option A)
ggplot(substorms, aes(x=Longitude, y=Latitude, group=ID)) +
  geom_polygon(data=map_data("world"), 
               aes(x=long, y=lat, group=group),
               fill='gray20', colour='gray10', size=0.2) +
  geom_path(data=substorms, 
            aes(group=ID, colour=Wind.WMO.), 
            alpha=0.6, size=0.7) +
  labs(x="", y="", colour="Wind \n(knots)") +
  xlim(-138, -20) +
  ylim(3, 55) +
  theme(#plot.background = element_rect(fill = "gray10"),
        panel.background = element_rect(fill = 'gray10'),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  ggtitle("Storm Trajectories 1999 - 2010")



# hurricanes by Month
ggplot(substorms, aes(x=Longitude, y=Latitude, group=ID)) +
  geom_polygon(data=map_data("world"), 
               aes(x=long, y=lat, group=group),
               fill='gray15', colour='gray10', size=0.2) +
  geom_path(data=substorms, 
            aes(group=ID, colour=Wind.WMO.), size=0.5) +
  xlim(-138, -20) +
  ylim(3, 55) +
  labs(x="", y="", colour="Wind \n(knots)") +
  facet_wrap(~ Month) +
  theme(#plot.background = element_rect(fill = "gray10"),
    panel.background = element_rect(fill = 'gray10'),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()) +
  ggtitle("Storm Trajectories by Month (1999 - 2010)")


# hurricanes by Year
ggplot(substorms, aes(x=Longitude, y=Latitude, group=ID)) +
  geom_polygon(data=map_data("world"), 
               aes(x=long, y=lat, group=group),
               fill='gray15', colour='gray10', size=0.2) +
  geom_path(data=substorms, 
            aes(group=ID, colour=Wind.WMO.), size=0.5) +
  xlim(-138, -20) +
  ylim(3, 55) +
  labs(x="", y="", colour="Wind \n(knots)") +
  facet_wrap(~ Season) +
  theme(#plot.background = element_rect(fill = "gray10"),
    panel.background = element_rect(fill = 'gray10'),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()) +
  ggtitle("Storm Trajectories by Year (1999 - 2010)")

