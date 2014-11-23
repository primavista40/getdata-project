label<-read.csv("UCI HAR Dataset/activity_labels.txt",header=FALSE,sep="")
#dealing with test
activity_label1<-read.csv("UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")

activity1<-ls(all.names=TRUE)
k<-activity_label1[,1]
subject1<-read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
names(subject1)<-"subject"
activity1<-label$V2[k]
features<-read.table("UCI HAR Dataset/features.txt")[,2]
set1<-cbind(subject=subject1,activity=activity1,read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE))
#dealing with train
activity_label2<-read.csv("UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
activity2<-ls(all.names=TRUE)
subject2<-read.table("UCI HAR Dataset/train/subject_train.txt")
names(subject2)<-"subject"
k<-activity_label2[,1]
activity2<-label$V2[k]
set2<-cbind(subject=subject2,activity=activity2,read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE))

combined<-rbind(set1,set2)
meanindex<-grep("mean\\(\\)",features)+2
stdindex<-grep("std\\(\\)",features)+2
index<-c(grep("mean\\(\\)",features),grep("std\\(\\)",features))
answer<-combined[,c(1,2,meanindex,stdindex)]

factor<-interaction(answer$activity,answer$subject)
s<-split(answer,factor)
Means<-sapply(s,function(x) colMeans(x[,3:68]))
rownames(Means)<-features[index]
write.table(Means,"data.txt",row.names=FALSE)