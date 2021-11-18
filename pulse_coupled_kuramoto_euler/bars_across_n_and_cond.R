library(ggplot2)
library(wesanderson)
library(plyr)

setwd('~/logos/group_drumming/pulse_coupled_kuramoto_euler')
X <- read.csv('pulse_coupled_kuramoto_euler_20211117-172022.csv',sep=',')

X$Coll = (X$Agg==1)*1
X$Coupled = X$K>0

unique(X$N)*1
unique(X$Coupled)*10
unique(X$Coll)*100

#X$iv <- X$N*100+X$Coupled*10+X$Coll
X$iv <- X$N*1+X$Coupled*100+X$Coll*10

xlabels = c('Solo,Inds,N2','Solo,Inds,N4','Solo,Inds,N8',
            'Solo,Aggr,N2','Solo,Aggr,N4','Solo,Aggr,N8',
            'Ens,Inds,N2','Ens,Inds,N4','Ens,Inds,N8',
            'Ens,Aggr,N2','Ens,Aggr,N4','Ens,Aggr,N8')

summary_stats_4groups <- ddply(X, 'iv', summarise, mean=mean(cv))
summary_stats_4groups.sem <- ddply(X, 'iv', summarise, mean=mean(cv), sem=sd(cv)/sqrt(length(cv)))
summary_stats_4groups.sem <- transform(summary_stats_4groups.sem, lower=mean-sem, upper=mean+sem)

colour_palette = wes_palette("FantasticFox1",3,type=("continuous"))

colour_palette = c('#000000','#222222','#555555','#888888')
ggplot(summary_stats_4groups, aes(x=as.factor(iv), y=mean)) +
  geom_bar(stat = "identity", alpha=1., size=.0,color='black',
           fill=c(colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[3],colour_palette[3],colour_palette[3],colour_palette[4],colour_palette[4],colour_palette[4])) +
  geom_errorbar(data=summary_stats_4groups.sem,aes(ymax=upper,ymin=lower),stat = "identity", alpha=1., size=1, width=.5) +
  labs(y = 'CV') +
  labs(x = '') +
  scale_x_discrete(labels=xlabels) +
  scale_y_continuous(breaks = seq(0.0,.3,.05)) +
  coord_cartesian(ylim = c(0.0,.25)) +
  theme_classic() +
  theme(legend.position="none",legend.title=element_blank()) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1., hjust=1, size=14)) +
  theme(axis.text.y = element_text(size=14)) +
  theme(axis.title.y = element_text(size=14))

if (FALSE){
  filename=paste("bars4_sim_cv_",format(Sys.time(), "%y%m%d-%H%M%S"),'.png',sep='')
  ggsave(filename,width=8,height=4,dpi=300)
}


# Same figure but without the silly aggregate in solo bar.
xlabels = c('Solo, Inds, N2','Solo, Inds, N4','Solo, Inds, N8',
            'Ensemble, Inds, N2','Ensemble, Inds, N4','Ensemble, Inds, N8',
            'Ensemble, Group-Aggr, N2','Ensemble, Group-Aggr, N4','Ensemble, Group-Aggr, N8')

x2<-X[!((X$K==0) & (X$Coll==1)),]

summary_stats_3groups <- ddply(x2, 'iv', summarise, mean=mean(cv))
summary_stats_3groups.sem <- ddply(x2, 'iv', summarise, mean=mean(cv), sem=sd(cv)/sqrt(length(cv)))
summary_stats_3groups.sem <- transform(summary_stats_3groups.sem, lower=mean-sem, upper=mean+sem)

colour_palette = c('#222222','#555555','#888888')
ggplot(summary_stats_3groups, aes(x=as.factor(iv), y=mean)) +
  geom_bar(stat = "identity", alpha=1., size=.0,color='black',
           fill=c(colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[3],colour_palette[3],colour_palette[3])) +
  geom_errorbar(data=summary_stats_3groups.sem,aes(ymax=upper,ymin=lower),stat = "identity", alpha=1., size=1, width=.5) +
  labs(y = 'CV') +
  labs(x = '') +
  scale_x_discrete(labels=xlabels) +
  scale_y_continuous(breaks = seq(0.0,.25,.05)) +
  coord_cartesian(ylim = c(0.0,.25)) +
  theme_classic() +
  theme(legend.position="none",legend.title=element_blank()) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1., hjust=1, size=14)) +
  theme(axis.text.y = element_text(size=14)) +
  theme(axis.title.y = element_text(size=14))

if (FALSE){
  filename=paste("bars3_sim_cv_",format(Sys.time(), "%y%m%d-%H%M%S"),'.png',sep='')
  ggsave(filename,width=8,height=6,dpi=300)
}
