## DEMO OF MULTIRESOLUTION ANALYSIS OF ACOUSTIC DATA (MAAD) - R SCRIPT
# Cluster regions of interest (ROIs) using High dimensional data clustering (HDDC)
library(HDclassif)

# Load data
rois_features=read.table('../output/rois_features.csv',sep=',',header=T)

# Cluster ROIs
set.seed(1234) # for repeatable example
data_hddc = hddc(rois_features,K=6,threshold=0.2,nb.rep = 10)

# Save results
write.table(data_hddc$class,file = '../output/rois_group.csv',row.names = F,col.names = T)