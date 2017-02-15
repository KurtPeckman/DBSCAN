# install factoextra pacakge which contains multishape data
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/factoextra")
library(factoextra)
data("multishapes")

df<-multishapes[,1:2]
set.seed(123)
km.res<-kmeans(df,5,nstart=25)
fviz_cluster(km.res,df,geom="point")

# by analysis using naked eye, we see 5 clusters (2 concentic and other 3)
# k means fails here as these points are non-convex in nature.
# let us try dbscan for same set of points

install.packages("fpc")
install.packages("dbscan")
# use dbscan() function under fpc library
library(fpc)
set.seed(123)
db<-dbscan(df,eps = 0.15,MinPts = 5)
plot(db,df,main="DBSCAN")
fviz_cluster(db,df,geom="point",ellipse = FALSE)
# Note that change in eps from 0.15 to 3 results in 4 clusters.
# result is very sensitive to values of eps and minpts passed.
print(db)
# note that it prints number of border and core(seed) points in each cluster
# cluster 0 is just a set of all outliers (black dots in the plot)


# Deciding optimal eps is very important.
# step1: For every point compute average distance of its k nearest neighbors
# (k is choosen as per minPts)
# Step2: Sort the average k nearest distance in ascending order, plot
# step3: Note a point where the distance increases suddenly (elbow point)
# elbow point is significant as it indicates a sharp rise in average distance
# this point may signify that points having greater than this optimal distance are part of different clusters

# we use function in dbscan to plot the k distance plot
detach(package:factoextra,unload=TRUE)
library(dbscan)
kNNdistplot(df,k = 5)
abline(h = 0.15,lty=2)

