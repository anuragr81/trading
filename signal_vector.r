
source('utils.r');
# @desc          - returns signal using ALL data provided
# @preconditions - assumes date_vector and price_vector are of same length
get_signal_at_last_point <- function(date_vector,price_vector,tol) {
  window_size <- 5
  ma_size <- 5
  if(ma_size>window_size){
    stop("must have ma_size <= window_size")
  }
  n <- length(price_vector);
  if (n>window_size) {
    print(paste("Using data from:",date_vector[1]," to ",date_vector[n]))
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
    if (price_vector[n]<mean(price_vector[(n-ma_size):n]*(1-tol) )) {
      print(paste("Buying on ",date_vector[n]," at ",price_vector[n]));
      return(1);
    } else if (price_vector[n]>mean(price_vector[(n-ma_size):n]*(1+tol) )){
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
  tol <- .005
  for ( i in seq(length(date_vector))) {
    # use different functions for different signal calculation criteria
    signals[i] = get_signal_at_last_point(date_vector=date_vector[1:(i-1)],price_vector=price_vector[1:(i-1)],tol=tol);
    print(paste("signal for ",date_vector[i], " was ", signals[i], " price today: ",price_vector[i]  ));
  }
  
  return(signals);
  
}
