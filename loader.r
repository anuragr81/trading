
#dat=read.csv('data/YHOO.html');

loader <- function (filename) {
   dat=read.csv(filename);
   dat$Date = strptime(dat$Date,"%Y-%m-%d");
   # ensure that the time series is sorted correctly
   # past values are on top
   if ( head(dat$Date,1) - tail(dat$Date,1) > 0 ) {
     # reverse the roworder
     dat = dat[rev(rownames(dat)),]
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

myrollapply <- function (dat,width,func){
   col = "Close";
   rowlen = dim(dat)[1];
   if( rowlen < width ) {
      stop('dim(dat)[1] < width');
   }
   returns_array = NULL;
   factor_array = NULL;
   date_array = NULL;
   for ( i in seq(1,rowlen-width+1)) {
       date_data = dat[i:(i+width-1),"Date"];
       col_data = dat[i:(i+width-1),col];
       #print (paste("(",head(date_data,1),"-",tail(date_data,1),") : ",returnVec(col_data),head(col_data,1),1e+5*returnVec(col_data)/head(col_data,1)));
       date_array=c(date_array,strftime(head(date_data,1),"%Y-%m-%d"));
       returns_array=c(returns_array,returnVec(col_data));
       factor_array=c(factor_array,1e+5*returnVec(col_data)/head(col_data,1));
   }
   output_df = data.frame(Date=date_array,ret=returns_array,real_factor=factor_array);

   write.csv(output_df,"/tmp/output.df.csv");
   return(output_df);
}

# simple and fast returns plot (for 10x5 blocks) would be:
# dat5 = dataNdaySpaced(loader("data/NAME.csv"),5);
# width = 10
# rets = rollapply(dat5$Close,width,returnVec)
# plot(dat5[1:(dim(dat5)[1]-width+1),]$Date,rets)
#
