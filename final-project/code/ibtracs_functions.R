
library(stringr)

#x = readLines('~/Documents/stat133/hurricanes.hdat', n = 10)
#x
#nchar(x)

#x[1]


# ===============================================
# File functions
# ===============================================

# initialize file 'storms.csv'
# with names of columns
init_storms <- function() {
  cat('id,date,days,name', '\n', file = 'storms.csv')
}

# initialize file 'tracks.csv'
# with names of columns
init_tracks <- function() {
  cat('id,date,period,stage,lat,long,wind,press', '\n', 
      file = 'tracks.csv')
}

# append line to a file
export_line <- function(x, file = '') {
  cat(x, '\n', file = file, append = TRUE)
}


# ===============================================
# Types of records:
# header, daily data, or trailer
# ===============================================

# is storm header record
is_header <- function(s) {
  nchar(s) == 85
}

# is daily data
is_daily <- function(s) {
  nchar(s) == 80
}

# is trailer record
is_trailer <- function(s) {
  nchar(s) == 36
}


# ===============================================
# Other helper functions
# ===============================================

# trim spaces and conver to numeric
num_trim <- function(s) {
  as.numeric(str_trim(s))
}



# ===============================================
# Header fields:
# Card# = Sequential card number starting at 00005 in 1851
# MM/DD/Year = Month, Day, and Year of storm
# Days = Number of days in which positions are available
# S# = Storm number for that particular year
# Total# = Storm number since since 1851
# Name = Storms only given official names since 1950
# US Hit = whether it made landfall (1=yes, 0=no)
# Hi US category = not utilized in recent years
# ===============================================

# extract storm number
header_storm_num <- function(s) {
  str_trim(substr(s, 31, 34))
}

# extract date
header_storm_date <- function(s) {
  str_trim(substr(s, 7, 16))
}

# extract number of days
header_num_days <- function(s) {
  str_trim(substr(s, 20, 21))
}

# extract storm name
header_storm_name <- function(s) {
  str_trim(substr(s, 36, 47))
}

# Card #
header_storm_card <- function(s) {
  substr(s, 1, 5)  # card
}

# month
header_storm_month <- function(s) {
  num_trim(substr(s, 7, 8))   # month
}

# day
header_storm_day <- function(s) {
  num_trim(substr(s, 10, 11))    # day
}

# year
header_storm_year <- function(s) {
  as.numeric(substr(s, 13, 16))   # year
}

#substr(x[1], 53, 53)  # US hit
#substr(x[1], 59, 59)  # Hi US Category

parse_header <- function(x) {
  paste(
    header_storm_num(x),
    header_storm_date(x),
    header_num_days(x),
    header_storm_name(x),
    sep = ',')
}



# ===============================================
# Daily data fields:
# Card# = Sequential card number starting at 00005 in 1851
# MM/DD/Year = Month, Day, and Year of storm
# Days = Number of days in which positions are available
# S# = Storm number for that particular year
# Total# = Storm number since since 1851
# Name = Storms only given official names since 1950
# US Hit = whether it made landfall (1=yes, 0=no)
# Hi US category = not utilized in recent years
# ===============================================

daily_track_month <- function(s) {
  substr(s, 7, 8)
}

daily_track_day <- function(s) {
  substr(s, 10, 11)
}

# month and day
daily_track_mmdd <- function(s) {
  substr(s, 7, 11)
}

daily_track_date <- function(s, year) {
  mmdd <- daily_track_mmdd(s)
  paste(mmdd, year, sep = '/')
}


# extract chunks of daily periods (0, 6, 12, 18)
daily_track_periods <- function(s) {
  periods <- 1:4
  # from what positions
  from <- c(12, 17 * periods + 12)[1:4]
  # to what positions
  to <- c(12, 17 * periods + 12)[-1] - 1
  # extract period chunks
  paste(str_sub(s, start = from, end = to),
        c('00h', '06h', '12h', '18h'))
}


period_stage <- function(s) {
  stage <- substr(s, 1, 1)
  switch(stage,
         '*' = 'cyclone',
         'S' = 'subtropical',
         'E' = 'extratropical',
         'W' = 'wave',
         'L' = 'remanent',
         NA)
}

period_lat <- function(s) {
  as.numeric(substr(s, 2, 4)) / 10
}

period_long <- function(s) {
  long <- as.numeric(substr(s, 5, 8)) / 10
  if (long > 180) {
    # negative longitude
    long <- (360 - long) * (-1)
  }
  long
}

period_wind <- function(s) {
  str_trim(substr(s, 9, 12))
}

period_pres <- function(s) {
  str_trim(substr(s, 13, 17))
}

period_time <- function(s) {
  substr(s, 19, 21)
}


build_period <- function(per, id, date) {
  paste(
    id,
    date,
    period_time(per),
    period_stage(per),
    period_lat(per),
    period_long(per),
    period_wind(per),
    period_pres(per),
    sep = ',')
}


all_zeros <- function(bperiod) {
  grepl('*.,0,0,0,0$', bperiod)
}


export_track <- function(x, file = '') {
  if (!all_zeros(x)) {
    export_line(x, file = file)
  } else {
    NULL
  }
}







# id,date,period,stage,lat,long,wind,press
# 1,04/22/1851,0h,subtropical,245,0610,30,1003
# 1,04/22/1851,6h,subtropical,246,0611,31,1002



