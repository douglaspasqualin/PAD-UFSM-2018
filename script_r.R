setwd("/home/douglas/Desktop/PAD-UFSM-2018")

tg <- read.table("output.txt", sep="\t" ) # read a table from the file, using TAB as separator

library(ggplot2)
library(lattice)
library(plyr)
library(Rmisc) #needed for summarySE function

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
  ggtitle("LULESH with 8 processors") +
  xlab("Number of OpenMP threads") +
  ylab("Time in seconds") +
  scale_y_continuous(limits=c(0,NA), breaks=yticks, labels=yticks) + 
  scale_x_discrete(limit = c("1", "2", "3", "4", "5", "6"),
                   labels = c("8","16","24", "32", "40","48")) +
  scale_fill_discrete(name="Implementation",
                      breaks=c("DASH", "OFFICIAL"),
                      labels=c("DASH", "OpenMP + MPI"))
