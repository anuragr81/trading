
#dat=read.csv('data/YHOO.html');
dat=read.csv(commandArgs(TRUE)[1]);
run_date=strptime(commandArgs(TRUE)[2],"%Y-%m-%d");
tx = strptime(dat$Date,"%Y-%m-%d");
dat$date<-tx
plot(dat$date,dat$Open,'l');
if (!is.na(run_date)){
 dat = dat[dat$date<=run_date,]
 print (dat[1:2,])

} else {
stop(paste("RunDate:",run_date)) 
}

