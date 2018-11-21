setwd("/home/douglas/Desktop/PADUFSM")

tg <- read.table("output.txt", sep="\t" ) # read a table from the file, using TAB as separator

library(ggplot2)
library(lattice)
library(plyr)
library(Rmisc) #needed for summarySE function

Legend <-"Implementation"
originalNames <- c("DASH", "OFFICIAL")
newNames <- c("DASH", "OpenMP + MPI")

# summarySE provides the standard deviation, standard error of the mean, and a (default 95%) confidence interval
tgc <- summarySE(tg, measurevar="V1", groupvars=c("V2","V3"))

yticks <- c(0,5,10,15,20,25,30,35,40,45,50,55,60)
#Plot graphic
ggplot(tgc, aes(x=V2, y=V1, fill=V3)) + 
  geom_bar(position=position_dodge(), stat="identity", 
           colour="black", # Use black outlines,
           size=.3) +     # Thinner lines
  geom_errorbar(aes(ymin=V1-sd, ymax=V1+sd),
                size=.3,    # Thinner lines
                width=.2,
                position=position_dodge(.9)) +  
  ggtitle(expression(atop("LULESH", atop(italic("8 processors and problem size 30^3"))))) +
  #ggtitle("LULESH") +
  xlab("Number of OpenMP threads per processor") +
  ylab("Time in seconds") +
  annotate("text", x = 6, y = 50, label = "Less is better") + 
  scale_y_continuous(limits=c(0,NA), breaks=yticks, labels=yticks) + 
  scale_x_discrete(limit = c("1", "2", "3", "4", "5", "6"),
                   #labels = c("8","16","24", "32", "40","48")) +
                   labels = c("1","2","3", "4", "5","6")) +
  scale_fill_manual(values = c("#006699", "#993300"),
                    name=Legend, # Legend label, use darker colors
                    breaks=originalNames,
                    labels=newNames) +
  theme(plot.title = element_text(hjust = 0.5)) #centered title


tgc2 <- tgc


newColSpeed <- 8
ColTimeValue <- 4
seqDash <- tgc2[1,ColTimeValue]
seqOpenMP <- tgc2[2,ColTimeValue]


#for 1 thread speedup is 1
tgc2[1,newColSpeed] <- 1
tgc2[2,newColSpeed] <- 1
#2 threads
tgc2[3,newColSpeed] <- seqDash/tgc2[3, ColTimeValue]
tgc2[4,newColSpeed] <- seqOpenMP/tgc2[4, ColTimeValue]
#3 threads
tgc2[5,newColSpeed] <- seqDash/tgc2[5, ColTimeValue]
tgc2[6,newColSpeed] <- seqOpenMP/tgc2[6, ColTimeValue]
#3 threads
tgc2[7,newColSpeed] <- seqDash/tgc2[7, ColTimeValue]
tgc2[8,newColSpeed] <- seqOpenMP/tgc2[8, ColTimeValue]
#4 threads
tgc2[7,newColSpeed] <- seqDash/tgc2[7,ColTimeValue]
tgc2[8,newColSpeed] <- seqOpenMP/tgc2[8,ColTimeValue]
#5 threads
tgc2[9,newColSpeed] <- seqDash/tgc2[9,ColTimeValue]
tgc2[10,newColSpeed] <- seqOpenMP/tgc2[10,ColTimeValue]
#6 threads
tgc2[11,newColSpeed] <- seqDash/tgc2[11,ColTimeValue]
tgc2[12,newColSpeed] <- seqOpenMP/tgc2[12,ColTimeValue]


yticks <- c(0,1,2,3,4,5,6,7,8,9,10)
ggplot(data=tgc2, aes(x=V2, y=V8, group=V3)) + 
  theme_bw(base_size=11,base_family=10) +
  geom_line(aes(linetype=V3,group=V3,color=V3),size=0.5) +
  geom_point(aes(color=V3,shape=V3),size=2)+
  geom_abline(intercept=0, slope=1, color="gray")+
  xlab("Number of OpenMP threads per processor") +
  ylab("SpeedUp") +
  ggtitle("Speedup") +
  scale_y_continuous(limits=c(0.5,6), breaks=yticks, labels=yticks) + 
  scale_x_discrete(limit = c("1", "2", "3", "4", "5", "6"),
                 #labels = c("8","16","24", "32", "40","48")) +
                 labels = c("1","2","3", "4", "5","6")) +
  scale_linetype_discrete(name=Legend, # Legend label, use darker colors
                          breaks=originalNames,
                          labels=newNames) +
  scale_shape_discrete(name=Legend, # Legend label, use darker colors
                       breaks=originalNames,
                       labels=newNames) +
  scale_colour_discrete(name=Legend, # Legend label, use darker colors
                        breaks=originalNames,
                        labels=newNames) +
  theme(plot.title = element_text(hjust = 0.5)) #centered title  
