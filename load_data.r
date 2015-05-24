
#dat=read.csv('data/YHOO.html');
dat=read.csv(commandArgs(TRUE)[1]);
tx = strptime(dat$Date,"%Y-%m-%d");
plot(tx,dat$Open,'l');

