
source('utils.r');
# @desc          - returns signal using ALL data provided
# @preconditions - assumes date_vector and price_vector are of same length
get_signal_at_last_point <- function(date_vector,price_vector,tol) {
  window_size <- 10
  ma_size <- 5
  if(ma_size>window_size){
    stop("must have ma_size <= window_size")
  }
  n <- length(price_vector);
  if (n>window_size) {
    
    print(paste("moving average=",mean(price_vector[n-ma_size:n])));
    print(paste("last_price=",price_vector[n]));
    
    # temporary stop condition <start>
    #if(n==20){
    #  dat<-data.frame(date=date_vector,price=price_vector);
    #  print(dat);
    #  plot(dat$date,dat$price);
    #  stop("Done");
    #}
    
    # temporary stop condition <end>
    
    # if condition is met (if price hits below mean-average then buy)
    if (price_vector[n]<mean(price_vector[(n-ma_size):n]-tol)) {
      print(paste("Buying on ",date_vector[n]," at ",price_vector[n]));
      return(1);
    } else if (price_vector[n]>mean(price_vector[(n-ma_size):n]+tol)){
      # we mean to sell if the price higher than the mean
      print(paste("Selling on ",date_vector[n]," at ",price_vector[n]));
      return(-1);
    } else{
      return (0)
    }
    
  }
  return(0);
}

#if ( numToBuy(price=price_vector[n],position=position,poisition_limit=position_limit)
# @desc - returns signal for all input vectors
get_signal_vector <- function(date_vector,price_vector) {
  
  if (!is.numeric(price_vector)) {
    stop("price_vector must be numeric");
  }
  if (!is.POSIXlt(date_vector)){
    stop("date_vector must be POSIXlt");
  }
  if (length(date_vector) != length(price_vector)){
    stop("date_vector and price_vector must be of the same size");
  }
  signals = array();
  position <- 0
  position_limit <- 1000
  tol <- 10
  for ( i in seq(length(date_vector))) {
    # use different functions for different signal calculation criteria
    signals[i] = get_signal_at_last_point(date_vector=date_vector[1:i],price_vector=price_vector[1:i],tol=tol);    
  }
  
  return(signals);
  
}
