plot_signals <- function(date_vector,open_prices_vector,close_prices_vector,signals){
  par(mfrow=c(2,2))
  plot(date_vector,open_prices_vector,'l');
  #plot(date_vector,c(0,diff(close_prices_vector)),type='l')
  plot(date_vector,signals,type='l')
  plot(date_vector,(close_prices_vector-open_prices_vector),type='l')
  plot(signals,(close_prices_vector-open_prices_vector));
  res=lm((close_prices_vector-open_prices_vector)~signals)
  abline(res);
  print(summary(res))
}


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
#  plot_signals(date_vector=dat$date,
#               open_prices_vector=dat$Open,
#               close_prices_vector=dat$Close,
#               signals=signals);
#  stop("DONE")
  #get projected PNL
  profit=get_pnl_vector(date_vector=dat$date,price_vector=dat$Close,signals=signals,start_position=0,position_limit=10000);
  print(paste("profit=",profit));
  par(mfrow=c(3,1))
  plot(dat$date,dat$Open,'l');
  plot(dat$date,c(0,diff(dat$Open)),type='l')
  plot(dat$date,profit);
  #hist(c(0,diff(dat$Open)))
  # how low is low is the question.
  # separation from monthly moving average is what we're looking at (however we're betting only on the moving average then)
  # to extend that we make sure that the second level change is also quite huge (i.e. the yearly average or a 3-month average moves a lot as well)
  #
  
} else {
  stop(paste("StartDate:",start_date,"EndDate:",end_date))
}


