####################################################################################
#  PVtest ANOVA and Noise Analysis
####################################################################################

library(readxl)
library(emmeans)
# library(lme4)
library(here)
# library(tidyr)
library(EMSaov)

###################################################################################
#  Read Pressure & Vacuum data                                                                     #
###################################################################################
Press <- read_excel(paste0(here(),"/FlowData.xlsx"), 
                    sheet = "API2000 Pressure", skip = 1)[,1:16]
Vac   <- read_excel(paste0(here(),"/FlowData.xlsx"), 
                    sheet = "API2000 Vacuum", skip = 1)[,1:16]
PV <- rbind(Press,Vac)
  PV$diam.nom <- as.character(PV$diam.nom)
  PV$dp.nom <- as.character(PV$dp.nom)

# Complete data: vendors A,B,E,F; pressures 2,3,4,5

PV.c <- PV[which(PV$dp.iwc > 0 & PV$dp.nom>1 & !(PV$vend %in% c("C","D"))),]

#############################################################
#  Analysis of Variance
#############################################################
# Variables
# ---------
#  SCFH.obs : measured flow rate
#  dp.psi   : measured difference between inlet and outlet pressure (psi)
#   
#  Factors
#   diam.nom  : nominal diameter of orifice
#   dp.nom    : nominal difference betw. inlet and outle pressure
#   rig       : test rig (5th or 7th edition)
#   vend      : vendor 
#   pv        : pressure or vacuum condition
#############################################################  
AOV <- function(mode)  {
  data <- as.data.frame(PV.c[which(PV.c == substr(mode,1,1)),])
  data$y <- log(data$SCFH.obs)
  
  #  Full ANOVA model
  
  AOV.lm <- lm(log(SCFH.obs) ~ diam.nom*dp.nom + vend + vend:diam.nom +vend:dp.nom, 
               data = data) 
  EMS.lm <- EMSanova(y ~ diam.nom*dp.nom*vend,data=data,type=c("F","F","R"),approximate=TRUE)
  
  # Full model anova table
  AOV <- anova(AOV.lm) 
  print(AOV)
  write.csv(AOV,file=paste0("AOV_",mode,".csv"))

  # consensus flow rates
  
  consensus.EMM <- emmeans(AOV.lm,~ diam.nom*dp.nom)
    consensus <- as.data.frame(print(summary(regrid(consensus.EMM))))
    consensus$diam.nom <- as.numeric(as.character(consensus$diam.nom))
    consensus$dp.nom <- as.numeric(as.character(consensus$dp.nom))
    sort <- order(consensus$diam.nom,consensus$dp.nom)
    consensus <- consensus[sort,]
    colnames(consensus)[3:4] <- c("SCFH","StdErr")
    
    # Table
    write.csv(consensus,file=paste0("Consensus_",mode,".csv"))
    
    # Graph
    y=consensus$SCFH/1000
    x=consensus$dp.nom
    d=consensus$diam.nom
    n <- length(d)
    pch = rep(19,n)
      pch[which(d==6)]=15
      pch[which(d==10)]=17
    plot(y~x,log="y",ylim=c(1,100),pch=pch,cex=1.5, xaxt="n",
         xlab="Pressure (inwc)",ylab="FLOW (1000 scfh)",main=paste("Consensus Flow Rate under ",mode))
         axis(side=1,at=c(2,3,4,5))
         legend("bottomright",c(" 2 in"," 6 in","10 in"),pch=c(19,15,17))
         for(diam in c(2,6,10)){
           which <- which(d==diam)
           lines(y[which]~x[which])
         }
  
  # vendors vs consensus      
  vend.EMM <- emmeans(AOV.lm,"vend")
  vend.deviations <-contrast(vend.EMM, 
                             list(A = c( .75,-.25,-.25,-.25),
                                  B = c(-.25, .75,-.25,-.25),
                                  E = c(-.25,-.25, .75,-.25),
                                  F = c(-.25,-.25,-.25, .75)))
  vend.vs.con <- as.data.frame(summary(vend.deviations))
  colnames(vend.vs.con)[1] = "vend"

  df <- vend.vs.con$df[1]
  se <- vend.vs.con$SE[1]
  two.sigma <- qt(.975,df)*se
  
  vend.vs.con$percent <- 100*(exp(vend.vs.con$estimate)-1)
  vend.vs.con$lower   <- 100*(exp(vend.vs.con$estimate-two.sigma)-1)
  vend.vs.con$upper   <- 100*(exp(vend.vs.con$estimate+two.sigma)-1)
  vend.vs.con <- vend.vs.con[,c("vend","percent","lower","upper")]
  print(vend.vs.con)
  write.csv(vend.vs.con,file=paste0("vendor_vs_consensus_",mode,".csv"))
  
  # Total noise
  AOV.vend.lm <- lm(log(SCFH.obs) ~ diam.nom*dp.nom + vend, 
               data = data) 
  total.noise <- (exp(residuals(AOV.vend.lm))-1)*100
  
  
  palette <- c("black","red","blue","green")
  shapes <- c(22,23,24,25)
  
  col <- palette[as.numeric(as.factor(data$vend))]
  pch <- shapes[as.numeric(as.factor(data$vend))]
  # whole part of x is diameter rank (1,2,3); fractional part is pressure (-.15,-.05,.05,15)
  x <- as.numeric(data$diam.nom) 
    x[which(x==2)]  <-1
    x[which(x==6)]  <-2
    x[which(x==10)] <-3
    x <- x + (as.numeric(factor(data$dp.nom))-2.5)/10
  # ordinates of dotted lines
  v.bias <- round(vend.vs.con$percent,1)
  # wide right margin
  par(oma=c(0,0,0,3))
  ylim<- c(5*floor(min(v.bias)/5),5*ceiling(max(v.bias)/5))
    y.min <- min(ylim)
  plot(total.noise ~ x,type="p",col=col,pch=pch,bg=col,
       xaxt="n",ylim = ylim,main=paste0("Total Noise under ", mode),
       xlab="Nominal orifice diameter",
       ylab="Percent of Consensus Flow Rate")
  # nominal inwc tick marks
    axis(side=1,at=c(1,2,3),labels=c('2"','6"','10"'))
      axis(side=1,at=c(.85,.95,1.05,1.15),labels=c(NA,NA,NA,NA),tck=.02)
      axis(side=1,at=c(.85,.95,1.05,1.15)+1,labels=c(NA,NA,NA,NA),tck=.02)
      axis(side=1,at=c(.85,.95,1.05,1.15)+2,labels=c(NA,NA,NA,NA),tck=.02)
    text(y=y.min+1,x=1.70,labels="inwc:")
    text(y=rep(y.min+1,3),x=c(.85,.95,1.05,1.15)+1,labels=c(2,3,4,5),cex=.8)
      
  
    axis(side=4,at=round(vend.vs.con$percent,1),las=2,tck=0)
      mtext("Vendor bias (% CFR)",side=4,line=3)
    legend("top",c("Vend: ","A","B","E","F"),pch=c(NA,shapes),lty=c(NA,2,2,2,2),
           col=c("black",palette),pt.bg=c("black",palette), ncol=5,bty="n",x.intersp = .5)
    for(v in 1:4) {
      lines(y=rep(vend.vs.con$percent[v],2),x=c(0,6),lty=2,col=palette[v],lwd=2)
    }
    
  # Vendor by Orifice bias
    # Noise
    AOV.vend.lm <- lm(log(SCFH.obs) ~ diam.nom*dp.nom + vend, 
                         data = data) 
    AOV.vendXorifice.lm <- lm(log(SCFH.obs) ~ diam.nom*dp.nom + vend + diam.nom:vend, 
                         data = data) 
    EMM.vend <- as.data.frame(emmeans(AOV.vend.lm, ~ diam.nom*vend))
    EMM.vendXorifice <- as.data.frame(emmeans(AOV.vendXorifice.lm, ~ diam.nom*vend))
    y <- 100*(exp(EMM.vend$emmean-EMM.vendXorifice$emmean)-1)
    x <- as.numeric(EMM.vendXorifice$diam.nom)
    v.bias <- round(vend.vs.con$percent,1)
    col <- palette[EMM.vendXorifice$vend]
    pch <- shapes[EMM.vendXorifice$vend] 
    plot(y ~ x,type="p",col=col,pch=pch,bg=col,
         xaxt="n",ylim = ylim,main=paste0("Vendor bias by Orifice size under ",mode),
         xlab="Nominal orifice diameter",
         ylab="Percent of Consensus Flow Rate")
    axis(side=1,at=c(1,2,3),labels=c('2"','6"','10"'))
    axis(side=4,at=round(vend.vs.con$percent,1),las=2,tck=0)
    mtext("Vendor bias (% CFR)",side=4,line=3)
    legend("top",c("Vend: ","A","B","E","F"),pch=c(NA,shapes),lty=c(NA,2,2,2,2),
           col=c("black",palette),pt.bg=c("black",palette), ncol=5,bty="n",x.intersp = .5)
    for(v in 1:4) {
      lines(y=rep(vend.vs.con$percent[v],2),x=c(0,6),lty=2,col=palette[v],lwd=2)
    }
    
    # pure error
    AOV.full.lm <- lm(log(SCFH.obs) ~ diam.nom*dp.nom + vend + vend:diam.nom + vend:dp.nom, 
                      data = data) 
   
    pure.error <- 100*(exp(residuals(AOV.full.lm))-1)
    col <- palette[as.numeric(as.factor(data$vend))]
    pch <- shapes[as.numeric(as.factor(data$vend))]
    x <- x + (as.numeric(factor(data$dp.nom))-2.5)/10
    v.bias <- round(vend.vs.con$percent,1)
    plot(pure.error ~ x,type="p",col=col,pch=pch,bg=col,
         xaxt="n",ylim = ylim,main=paste0("Pure error under ",mode),
         xlab="Nominal orifice diameter",
         ylab="Percent of Consensus Flow Rate")
    axis(side=1,at=c(1,2,3),labels=c('2"','6"','10"'))
    # nominal inwc tick marks
    axis(side=1,at=c(1,2,3),labels=c('2"','6"','10"'))
    axis(side=1,at=c(.85,.95,1.05,1.15),labels=c(NA,NA,NA,NA),tck=.02)
    axis(side=1,at=c(.85,.95,1.05,1.15)+1,labels=c(NA,NA,NA,NA),tck=.02)
    axis(side=1,at=c(.85,.95,1.05,1.15)+2,labels=c(NA,NA,NA,NA),tck=.02)
    text(y=y.min+1,x=1.70,labels="inwc:")
    text(y=rep(y.min+1,3),x=c(.85,.95,1.05,1.15)+1,labels=c(2,3,4,5),cex=.8)
    
    axis(side=4,at=round(vend.vs.con$percent,1),las=2,tck=0)
    mtext("Vendor bias (% CFR)",side=4,line=3)
    legend("top",c("Vend: ","A","B","E","F"),pch=c(NA,shapes),lty=c(NA,2,2,2,2),
           col=c("black",palette),pt.bg=c("black",palette), ncol=5,bty="n",x.intersp = .5)
    for(v in 1:4) {
      lines(y=rep(vend.vs.con$percent[v],2),x=c(0,6),lty=2,col=palette[v],lwd=2)
    }
}    

AOV("Pressure")
AOV("Vacuum")

