library(ggplot2)
library(wesanderson)

setwd('/home/dobri/logos/mcmc/group_drumming/pulse_coupled_kuramoto_sims')
X <- read.csv('pulse_coupled_kuramoto_20210617-220725.csv',sep=',')

X$Coll = (X$Agg==1)*1
X$Coupled = X$K>0

unique(X$N)*100
unique(X$Coupled)*10
unique(X$Coll)

X$iv <- X$N*100+X$Coupled*10+X$Coll

# xlabels1 = c('N2,Solo,Inds','N2,Ens,Inds',
#              'N4,Solo,Inds','N4,Ens,Inds',
#              'N8,Solo,Inds','N8,Ens,Inds')
# 
# xlabels2 = c('Solo,Inds','Solo,Aggr','Ens,Inds','Ens,Aggr',
#              'Solo,Inds','Solo,Aggr','Ens,Inds','Ens,Aggr',
#              'Solo,Inds','Solo,Aggr','Ens,Inds','Ens,Aggr')
# 
# colour_palette = wes_palette("Darjeeling1",3,type=("continuous"))
# g<-list('vector',2)
# for (dv in c(1,2)){
#   x$dv<-x[,dv+10]
#   if (dv==1) {
#     dv_label = 'Speeding up'
#     xx<-x[x$Coll==0,]
#     xx$iv <- xx$condngroup
#   }
#   if (dv==2) {
#     dv_label = 'CV'
#     xx<-x
#     xx$iv <- xx$condn
#   }
#   g[[dv]] <- ggplot(xx, aes(x=as.factor(iv), y=dv, color=as.factor(N))) + # , fill=as.factor(N)
#     geom_violin(alpha=.85, size=1, color='black') +
#     #geom_bar(stat = "summary", fun='mean', alpha=1., size=2) +
#     #geom_errorbar(stat = "summary", fun='mean_sdl', alpha=1., size=1, fun.args = list(mult = 1)) +
#     geom_jitter(size=1.2, alpha=.85, width=.3, height = .0) +
#     theme_classic() +
#     theme(legend.position="none",legend.title=element_blank()) +
#     scale_colour_manual(values=colour_palette) +
#     labs(y = dv_label) +
#     labs(x = 'Condition')
#   if (dv==1) {
#     g[[dv]] <- g[[dv]] + scale_x_discrete(labels=xlabels1)
#     #g[[dv]] <- g[[dv]] + scale_y_continuous(breaks = seq(-.25,.3,.1), limits = c(-.25,.3))
#   }
#   if (dv==2) {
#     g[[dv]] <- g[[dv]] + scale_x_discrete(labels=xlabels2)
#     #g[[dv]] <- g[[dv]] + scale_y_continuous(breaks = seq(0,.3,.05), limits = c(0.0,.1))
#   }
# }
# multiplot(plotlist=g,cols=2)
# 
# filename=paste("cv_b_limit_bpm_",Sys.Date(),'.png',sep='')
# if (FALSE){
#   png(filename=filename,width=8,height=6,units="in",res=300)
#   multiplot(plotlist=g,cols=1)
#   dev.off()
# }


library(plyr)

xlabels = c('N2,Solo,Inds','N2,Solo,Aggr','N2,Ens,Inds','N2,Ens,Aggr',
            'N4,Solo,Inds','N4,Solo,Aggr','N4,Ens,Inds','N4,Ens,Aggr',
            'N8,Solo,Inds','N8,Solo,Aggr','N8,Ens,Inds','N8,Ens,Aggr')

means <- ddply(X, 'iv', summarise, mean=mean(cv))
means.sem <- ddply(X, 'iv', summarise, mean=mean(cv), sem=sd(cv)/sqrt(length(cv)))
means.sem <- transform(means.sem, lower=mean-sem, upper=mean+sem)

# means <- ddply(X, 'iv', summarise, mean=mean(ITI))
# means.sem <- ddply(X, 'iv', summarise, mean=mean(ITI), sem=sd(cv)/sqrt(length(ITI)))
# means.sem <- transform(means.sem, lower=mean-sem, upper=mean+sem)

colour_palette = wes_palette("FantasticFox1",3,type=("continuous"))

ggplot(means, aes(x=as.factor(iv), y=mean)) +
  geom_bar(stat = "identity", alpha=1., size=.0,color='black',
           #color=c(colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[3],colour_palette[3]),
           fill=c(colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[3],colour_palette[3],colour_palette[3],colour_palette[3])) +
  geom_errorbar(data=means.sem,aes(ymax=upper,ymin=lower),stat = "identity", alpha=1., size=1, width=.5) +
  labs(y = 'CV') +
  labs(x = '') +
  scale_x_discrete(labels=xlabels) +
  #scale_y_continuous(breaks = seq(0.0,.3,.025), limits = c(0.0,.3)) +
  theme_classic() +
  theme(legend.position="none",legend.title=element_blank()) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1., hjust=1, size=14)) +
  theme(axis.text.y = element_text(size=14)) +
  theme(axis.title.y = element_text(size=14))

if (FALSE){
  filename=paste("bars_sim_cv_",Sys.Date(),'.png',sep='')
  ggsave(filename,width=8,height=4,dpi=300)
}


# Same figure but without the silly aggregate in solo bar.
xlabels = c('N2, Solo, Inds','N2, Ensemble, Inds','N2, Ensemble, Group-Aggr',
            'N4, Solo, Inds','N4, Ensemble, Inds','N4, Ensemble, Group-Aggr',
            'N8, Solo, Inds','N8, Ensemble, Inds','N8, Ensemble, Group-Aggr')

x2<-X[!((X$K==0) & (X$Coll==1)),]

means <- ddply(x2, 'iv', summarise, mean=mean(cv))
means.sem <- ddply(x2, 'iv', summarise, mean=mean(cv), sem=sd(cv)/sqrt(length(cv)))
means.sem <- transform(means.sem, lower=mean-sem, upper=mean+sem)

ggplot(means, aes(x=as.factor(iv), y=mean)) +
  geom_bar(stat = "identity", alpha=1., size=.0,color='black',
           #color=c(colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[3],colour_palette[3]),
           fill=c(colour_palette[1],colour_palette[1],colour_palette[1],colour_palette[2],colour_palette[2],colour_palette[2],colour_palette[3],colour_palette[3],colour_palette[3])) +
  geom_errorbar(data=means.sem,aes(ymax=upper,ymin=lower),stat = "identity", alpha=1., size=1, width=.5) +
  labs(y = 'CV') +
  labs(x = '') +
  scale_x_discrete(labels=xlabels) +
  scale_y_continuous(breaks = seq(0.025,.125,.025), limits = c(0.0,.125)) +
  theme_classic() +
  theme(legend.position="none",legend.title=element_blank()) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1., hjust=1, size=14)) +
  theme(axis.text.y = element_text(size=14)) +
  theme(axis.title.y = element_text(size=14))

if (FALSE){
  filename=paste("bars3_sim_cv_",Sys.Date(),'.png',sep='')
  ggsave(filename,width=8,height=6,dpi=300)
}
