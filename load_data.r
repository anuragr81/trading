
dat=read.csv('data.csv');
tx = strptime(dat$Date,"%Y-%m-%d");
plot(tx,dat$Open);

