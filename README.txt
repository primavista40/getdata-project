This file will describe how I can come up with the "data.txt" which will be done by describing each line of code from "run_analysis.R" by adding comments to it.

#1. Create a 2 by 6 list containing the index and the corresponding activity type
label<-read.csv("UCI HAR Dataset/activity_labels.txt",header=FALSE,sep="")
#dealing with the test set
# 2. loading the activity type index from the file
activity_label1<-read.csv("UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")
#3. create an empty list for the type of activity performed for each observation.
activity1<-ls(all.names=TRUE)
k<-activity_label1[,1]
#4. Look up for the corresponding activity for each observation
activity1<-label$V2[k]
#5. create a list indicating the subject being used for each observation and then assign the header as "subject"
subject1<-read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
names(subject1)<-"subject"
#6. read the list of all of the features being measured and then combine the information about subject, activity and measurements altogether by binding the columns
features<-read.table("UCI HAR Dataset/features.txt")[,2]
set1<-cbind(subject=subject1,activity=activity1,read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE))
#7. We then treat the train data set in a similar fashion
activity_label2<-read.csv("UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
activity2<-ls(all.names=TRUE)
subject2<-read.table("UCI HAR Dataset/train/subject_train.txt")
names(subject2)<-"subject"
k<-activity_label2[,1]
activity2<-label$V2[k]
set2<-cbind(subject=subject2,activity=activity2,read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE))

#8. We then combine the test set and the train set together
combined<-rbind(set1,set2)
#9. We only need to select the features that contains mean() and std(). Hence, we only need to choose the relevant index.
meanindex<-grep("mean\\(\\)",features)+2
stdindex<-grep("std\\(\\)",features)+2
index<-c(grep("mean\\(\\)",features),grep("std\\(\\)",features))
answer<-combined[,c(1,2,meanindex,stdindex)]
#10. We then create a new factor which combines the information about the activity and the subject number. Then, we group the data by this factor.
factor<-interaction(answer$activity,answer$subject)
s<-split(answer,factor)
#11. We use sapply to columns 3:68(as columns 1,2 are non numeric)
Means<-sapply(s,function(x) colMeans(x[,3:68]))
#12. assign the name of each rows as the corresponding features
rownames(Means)<-features[index]
#13. Create the data.txt as requested. (It was asked that row.names to be set as FALSE. However, the data could be more descriptive if set as TRUE)
write.table(Means,"data.txt",row.names=FALSE)
#Note that this only works if the relevant data is contained in the working directory.