# ==================================================
# Title: Skeleton script
# Author: Gaston Sanchez
# Date: mm/dd/yyyy
# Description: Creates the filesystem structure
#              for the final project, and downloads
#              raw data files
# ==================================================

# directory names
dirs <- c(
  'code',
  'rawdata',
  'data',
  'analysis',
  'slides',
  'images')

# create project directories
lapply(dirs, dir.create)

# add readme
file.create('README.md')


# ==================================================
# Download raw data files
# ==================================================

# East Pacific basin (cxml)
# East Pacific basin (csv)
# North Atlantic basin (csv)
# North Atlantic basin (hurdat)

noaa_url <- 'ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo'
noaa_files <- c(
  EP_xml = '/cxml/basin/Basin.EP.ibtracs_wmo.v03r06.cxml',
  EP_csv = '/csv/basin/Basin.EP.ibtracs_wmo.v03r06.csv',
  NA_csv = '/csv/basin/Basin.NA.ibtracs_wmo.v03r06.csv',
  NA_hdat = '/hurdat_format/basin/Basin.NA.ibtracs_hurdat.v03r06.hdat'
)
data_files <- paste0(noaa_url, noaa_files)

# destination files
dest_files <- c(
  'epbasin.xml',
  'epbasin.csv'
  'nabasin.csv', 
  'nabasin.hdat'
)
# they'll go to rawdata
raw_files <- paste0('rawdata/', dest_files)

# download data files
mapply(download.file, data_files, raw_files)


