
#dat=read.csv('data/YHOO.html');

loader <- function (filename) {
   dat=read.csv(filename);
   dat$Date = strptime(dat$Date,"%Y-%m-%d");
   # ensure that the time series is sorted correctly 
   # past values are on top
   if ( head(dat$Date,1) - tail(dat$Date,1) > 0 ) {
     # reverse the roworder 
     dat = dat[rev(rownames(dat)),];
   }
   return (dat);
}

dataNdaySpaced <- function(dat,n){
  return (dat[as.integer(strftime(dat$Date,"%d"))%%n==0,])
}

returnN <- function(dat,startN,N,fieldname){
   start = (head(dat[startN:(startN+N),],1));
   end = (tail(dat[startN:(startN+N),],1));
   #print(paste("start=",start$Date," end=",end$Date));
   return (end[,fieldname]/start[,fieldname]-1);
}

returnVec <- function(dat){
   return (tail(dat,1)/head(dat,1)-1);
}

# simple and fast returns plot (for 10x5 blocks) would be:
# dat5 = dataNdaySpaced(loader("data/NAME.csv"),5);
# width = 10
# rets = rollapply(dat5$Close,width,returnVec)
# plot(dat5[1:(dim(dat5)[1]-width+1),]$Date,rets)
# 
