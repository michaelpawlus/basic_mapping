library(ggplot2)
library(ggmap)

setwd("C:/Users/pawlusm/Desktop/decTree")

## gets map of grand rapids
GRMap <- qmap('grand rapids', zoom = 12,color = 'bw', legend = 'topleft')
GRMap

geocode("Grand Valley State University")

## gr map
gr.map.code <- get_map(location = 'Grand Rapids', source = 'google', maptype = 'roadmap', zoom = 13)
ggmap(gr.map.code)

## gr alt ver
gr.bw <- get_map(location = 'Grand Rapids', source = 'stamen', maptype = 'toner')
ggmap(gr.bw)

## alt map
home <- geocode("2556 Raymond Ave. SE, Grand Rapids, MI 40507")
home.map.code <- get_map(location = "2556 Raymond Ave. SE, Grand Rapids, MI 40507", source = 'google', maptype = 'roadmap', zoom = 14)
ggmap(home.map.code)

## ada map

# read in ada people and clean up columns
ada <- read.csv("ada1.csv") 
ada$addr <- as.character(ada$addr)
ada$mg_donor <- as.factor(ada$mg_donor)

# get a map of Ada using the Google API
ada.map.code <- get_map(location = "Ada, MI", source = 'google', maptype = 'roadmap', zoom = 13)

# obtain long/lat for all addresses in the area and cbind with ada list
ada.ll <- geocode(ada$addr)
ada <- cbind(ada, ada.ll)

# plot points on a map
ggmap(ada.map.code) + geom_point(size = 5, alpha = 1/2, aes(lon,lat, color=mg_donor), data = ada) + geom_polygon(aes(x = c(-85.51,-85.4675,-85.4675,-85.51), y = c(42.95,42.95,42.935,42.935)), color = "black", alpha = 0.05)

# look at those within some interesting area
ada.mg.neighbors <- ada[abs(ada$lon) < 85.51 & abs(ada$lon) > 85.4675 & ada$lat > 42.935 & ada$lat < 42.95,]

# output a list of names
write.csv(ada.mg.neighbors,"ada_mg_neighbors.csv",row.names=FALSE,quote=TRUE)

# check distance query balance
distQueryCheck()

# check geocode query balance
geocodeQueryCheck()
