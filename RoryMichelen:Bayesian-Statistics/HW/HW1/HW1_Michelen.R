library(ggplot2)
library(tidyverse)


# Question 1
t<-seq(0,1,by=0.001)
l<-c(1,2,1/2,1/3,1)

prob_e<-function (t,l){
  return(exp(-1*l*t))
}

probs.at.t<-as.data.frame(t)
probs.at.t$H1<-prob_e(t,5)
probs.at.t$H2<-1-probs.at.t$H1
probs.at.t$s.gv.H1<-prob_e(t,1)+
                      prob_e(t,3)-
                      (prob_e(t,1)*prob_e(t,3))
probs.at.t$s.gv.H2<-(prob_e(t,1)*prob_e(t,2))+
                      (prob_e(t,3)*prob_e(t,4))-
                      (prob_e(t,1)*prob_e(t,2)*prob_e(t,3)*prob_e(t,4))

probs.at.t$s<-with((H1*s.gv.H1)+(H2*s.gv.H2),data=probs.at.t)

# Part A
#Plot
probs.at.t%>%
  ggplot(aes(x=t,y=s))+geom_line(group=1)+labs(x="Time",y="Probability of Succes",title="Probability of Success over Time")

# Time =1/2
probs.at.t%>%
  dplyr::filter(t==0.5)%>%
  select(s)

# Part B
probs.at.t$H1.gv.s<-with(s.gv.H1*H1/s,data=probs.at.t)

probs.at.t%>%
  dplyr::filter(t==0.5)%>%
  select(H1.gv.s)


