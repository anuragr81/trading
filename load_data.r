
source ("loader.r");
source ("signal_vector.r");
source ("pnl_vector.r");
#dat=read.csv('data/YHOO.html');
dat=read.csv(commandArgs(TRUE)[1]);
start_date=strptime(commandArgs(TRUE)[2],"%Y-%m-%d");
end_date=strptime(commandArgs(TRUE)[3],"%Y-%m-%d");
tx = strptime(dat$Date,"%Y-%m-%d");
dat$date<-tx
if ( head(dat$date,1) - tail(dat$date,1) > 0 ) {
      # reverse the roworder
      dat = dat[rev(rownames(dat)),]
}

# dat$date <- strptime(dat$Date,"%Y-%m-%d")

if (!is.na(start_date) && !is.na(end_date) ){

 dat = dat[dat$date<=end_date & dat$date>=start_date,]
 #get signal vector
 signals = get_signal_vector(date_vector=dat$date,price_vector=dat$Close)
 #get projected PNL
 get_pnl_vector(date_vector=dat$date,price_vector=dat$Close,signals=signals,start_position=0,position_limit=10000);
 
 par(mfrow=c(2,1))
 plot(dat$date,dat$Open,'l');
 plot(dat$dat,c(0,diff(dat$Open)),type='l')

 #hist(c(0,diff(dat$Open)))
 # how low is low is the question.
 # separation from monthly moving average is what we're looking at (however we're betting only on the moving average then)
 # to extend that we make sure that the second level change is also quite huge (i.e. the yearly average or a 3-month average moves a lot as well)
 #

} else {
stop(paste("StartDate:",start_date,"EndDate:",end_date))
}


