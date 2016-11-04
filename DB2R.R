# R code for Getting Access data into R using RODBC.

# To a big share, the following code was copied from the Github link listed below:
#################################################################
### Sources:
### R-bloggers.com:
#   https://www.r-bloggers.com/getting-access-data-into-r/
### World Database
#   https://dev.mysql.com/doc/index-other.html

#################################################################


#################################################################
### Setup
#################################################################

rm(list = ls())
graphics.off()

# Installing RODBC, Loading RODBC 
libraries = c("RODBC")
lapply(libraries,function(x)if(!(x %in% installed.packages())){install.packages(x)})
lapply(libraries,require,quietly=TRUE,character.only=TRUE)

# getting access to the RODBC vignette.
vignette("RODBC")


#################################################################
### With a DSN Connection
#################################################################

# DSN need to be set up before via ODBC manager
# 32-bit R
xlsx  = odbcConnect("MyTestBook") 
accdb = odbcConnect("ToyDB")
# 32- or 64-bit R
mysql = odbcConnect("DBworld")


#################################################################
### NO DSN Connection 
#################################################################

# No DSN was set up before via ODBC manager

# working directory were data are stored
setwd("C:/Users/Johannes/Dropbox/Digital_Economics/data")

# 32-bit R
xlsx  = odbcConnectExcel2007("Test.xlsx")
accdb = odbcConnectAccess2007("Test.xlsx")

# 32- or 64-bit R
mysql = odbcDriverConnect('driver={MySQL ODBC 5.3 UNICODE Driver};Server=localhost;Database=world;User=root;Password=;Option=3')

#################################################################
### Browse and import tables from a database 
#################################################################


# Get names of the tables 
tbls = sqlTables(mysql)
tbls$TABLE_NAME

# Imports the city table
city = sqlFetch(mysql, "city")
str(city)

# Imports the city table with a query
qry = "SELECT * FROM city"
city = sqlQuery(mysql, qry)

# Show what variables are in city table: get column names
sqlColumns(mysql, "city")$COLUMN_NAME

# Import only cities with population more than one 1 Mio
qry = "SELECT * FROM city WHERE Population > 1000000"
big_city = sqlQuery(mysql, qry)
head(big_city)

# Imports the countrylanguage table
lang = sqlFetch(mysql, "countrylanguage")
# Import the countrylanguage table with a query
qry = "SELECT * FROM countrylanguage"
lang = sqlQuery(mysql, qry)
head(lang)


# Close connections, Always close connection to database!
odbcCloseAll()