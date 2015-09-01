# load libraries for creating maps in R

library(ggplot2)
library(ggmap)

# set working directory (the folder containing the csv file with the addresses that you will be mapping)

setwd("C:/Users/pawlusm/Desktop/decTree")

### ada map ###

########################################################################################

# Unfortunately, I can't add a sample file because addresses are required
# and identities can be obtained through address info

# For your csv, you only need the following columns:

# Unique ID

# Address (concatenated so address, city, state are all in one field)
# If you can't do this from your database, use =CONCATENATE() in Excel
# Where you place the cell numbers with address info in the parenthesis

# That is really all that you NEED however you may want to add some attribute

# For example, I include mg_donor which is just 1 or 0 if they are at a giving level

# Add anything else, for example, maybe names so you can see it in the output

# So, an example might look like:

# id      #  name          #  addr                     # mg_donor  #
#---------#----------------#---------------------------#-----------#
# 123     #  John Smith    #  987 Main St Portland OR  #  1        #
# 234     #  Jane Doe      #  555 State St Austin TX   #  0        #

# In this case, the map shows where there is a concentration of major donors

# I also include those that rank high in wealth

# The takeaway or action step is to see if those friends can be leveraged
# to help build relationships with others in the same neighborhood

########################################################################################

# read in csv and clean up columns (I use donors from the wealthy suburb of Ada, MI for this example)
ada <- read.csv("ada1.csv") 
ada$addr <- as.character(ada$addr)        # change address from factor to character string
ada$mg_donor <- as.factor(ada$mg_donor)   # change binary attribute from numeric to factor variable

# get a map of Ada using the Google API 
# (Change location to wherever you want the map to be and adjust zoom from 10 - 14 to get the size you want)
# (check this link for more easy options: https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/ggmap/ggmapCheatsheet.pdf)
ada.map.code <- get_map(location = "Ada, MI", source = 'google', maptype = 'roadmap', zoom = 13)

# obtain long/lat for all addresses in the area and then add the new columns to the ada list with cbind
ada.ll <- geocode(ada$addr)
ada <- cbind(ada, ada.ll)

# plot points on a map
# (geom_polygon can be ignored this just draws a bounding box around an interesting region)
ggmap(ada.map.code) + geom_point(size = 5, alpha = 1/2, aes(lon,lat, color=mg_donor), data = ada) + geom_polygon(aes(x = c(-85.51,-85.4675,-85.4675,-85.51), y = c(42.95,42.95,42.935,42.935)), color = "black", alpha = 0.05)

# your line of code may look like: 
# ggmap(map.variable) + geom_point(size = 5, alpha = 1/2, aes(lon,lat, color=attribute.column), data = csv.variable)
# where: 
#   map.variable      = name of the variable with the map object created above
#   attribute.column  = name of the column with the attribute variable (for example, major donor (1) or not (0))
#   csv.variable      = name of the variable for the csv dataset created above


# (optional): create a subset of the dataset from some interesting region
ada.mg.neighbors <- ada[abs(ada$lon) < 85.51 & abs(ada$lon) > 85.4675 & ada$lat > 42.935 & ada$lat < 42.95,]

# (optional): output a list of records from the interesting region 
# (set quote=TRUE if you have commas in your addresses)
write.csv(ada.mg.neighbors,"ada_mg_neighbors.csv",row.names=FALSE,quote=TRUE)

# check geocode query balance (you can do 2500 of these every 24 hours -- this shows how many are remaining)
geocodeQueryCheck()
