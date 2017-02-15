library(factoextra)
library(fpc)
library(dbscan)
data("iris")

# find optimal eps
kNNdistplot(iris[,1:4],k = 5)
abline(h=0.4,lty=2)

# apply dbscan 
set.seed(123)
db<-fpc::dbscan(iris[,1:4],eps=0.4,MinPts = 4)
db<-dbscan::dbscan(iris[,1:4],eps = 0.4,minPts = 4)
# dbscan package is faster than fpc in implementing dbscan(), 
# thus a better choice for large datasets
print(db)
fviz_cluster(db,iris[,1:4],geom = "point")


# Predict classes of flowers
library(caret)
index=createDataPartition(iris[,5],times = 2,p = 0.7)

train<-iris[index$Resample1,1:4]
train_target<-iris[index$Resample1,5]
test<-iris[-index$Resample2,1:4]
test_target<-iris[-index$Resample2,5]

db<-dbscan::dbscan(train,eps = 0.5,minPts = 3)
# performance on train set
table(db$cluster,train_target)
# performance on test set
set.seed(123)
pred<-predict(db,test,data=train)
table(pred,test_target)

# cluster 1 represents setosa
# cluster 2 represents versicolor
# cluster 3 represents virginica
