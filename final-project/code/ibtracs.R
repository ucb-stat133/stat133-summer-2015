
# IBTrACS
# International Best Track Archive for Climate Stewardship
https://www.ncdc.noaa.gov/ibtracs/index.php


# formats
https://www.ncdc.noaa.gov/ibtracs/index.php?name=wmo-formats

# Original HURDAT format
http://www.aoml.noaa.gov/hrd/data_sub/hurdat.html

# Data
https://www.ncdc.noaa.gov/ibtracs/index.php?name=wmo-data
# HURDAT data files
ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/hurdat_format/basin
# NA Basin
ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/hurdat_format/basin/Basin.NA.ibtracs_hurdat.v03r06.hdat

# try to reproduce these analyses
https://www.ncdc.noaa.gov/ibtracs/index.php?name=climatology
https://www.ncdc.noaa.gov/ibtracs/index.php?name=ibtracs-tab-num-ann-wmo

x = readLines('~/Documents/stat133/hurricanes.hdat', n = 10)
x
nchar(x)


x[1]
substr(x[1], 1, 5)    # Card
substr(x[1], 7, 8)    # month
substr(x[1], 10, 11)  # day
substr(x[1], 13, 16)  # year
substr(x[1], 20, 21)  # days
substr(x[1], 23, 24)  # year storm number
substr(x[1], 31, 34)  # storm number since 1895
substr(x[1], 36, 47)  # name
substr(x[1], 53, 53)  # US hit
substr(x[1], 59, 59)  # Hi US Category


# 0 hours (00Z)
as.numeric(substr(x[2], 13, 15)) / 10  # latitude
(360 - as.numeric(substr(x[2], 16, 19))/10)  # longitude
sub('\\s+', '', substr(x[2], 20, 23))  # wind
sub('\\s+', '', substr(x[2], 24, 28))  # press

# 06 hours (06Z)
as.numeric(substr(x[2], 30, 32)) / 10  # latitude
(360 - as.numeric(substr(x[2], 33, 36))/10)  # longitude
sub('\\s+', '', substr(x[2], 37, 40))  # wind
sub('\\s+', '', substr(x[2], 41, 45))  # press

# 12 hours (12Z)
as.numeric(substr(x[2], 47, 49)) / 10  # latitude
(360 - as.numeric(substr(x[2], 50, 53))/10)  # longitude
sub('\\s+', '', substr(x[2], 54, 57))  # wind
sub('\\s+', '', substr(x[2], 58, 62))  # press

# 18 hours (18Z)
as.numeric(substr(x[2], 64, 66)) / 10  # latitude
(360 - as.numeric(substr(x[2], 67, 70))/10)  # longitude
sub('\\s+', '', substr(x[2], 71, 74))  # wind
sub('\\s+', '', substr(x[2], 75, 79))  # press

