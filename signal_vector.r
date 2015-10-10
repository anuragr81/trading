
source('utils.r');

# @desc          - returns signal using ALL data provided
# @preconditions - assumes date_vector and price_vector are of same length
get_vol_signal_at_last_point <- function(date_vector,price_vector,tol) {
  window_size <- 5
  ma_size <- 5
  if(ma_size>window_size){
    stop("must have ma_size <= window_size")
  }
  n <- length(price_vector);
  
  status=list();
  status$signal=0;
  status$vector=c(0)
  if (n>window_size) {
    
    print(paste("Using data from:",date_vector[1]," to ",date_vector[n]))
    print(paste("last_price=",price_vector[n]));
    diff_price_vector = diff(price_vector)
    sz_diff_price_vector = length(diff_price_vector)
    status$vector = sd(diff_price_vector[(sz_diff_price_vector-window_size):sz_diff_price_vector]);
  }
  return(status);
  #return(0);
}

# @desc          - returns signal using ALL data provided
# @preconditions - assumes date_vector and price_vector are of same length
get_ma_signal_at_last_point <- function(date_vector,price_vector,tol) {
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

plot_signal_vectors<-function (test_results)
{
  # plotting test_results <start>
  len_signals = length(names(test_results));
  #             toString(summary(res)$coef[,"t value"][2]),
  print(paste("total number of signs: ",len_signals))
  par(mfrow=c(4,5))
  for (i in seq(len_signals)){
    
    sd_val = sd(test_results[[i]]);
    if (!is.na(sd_val) && sd_val<1 && length(test_results[[i]]) > 10){
      plot(test_results[[i]],xlab=
             paste(names(test_results)[i],"(sd=",sd_val,")")
      )
      print(paste(names(test_results)[i],"(sd=",sd_val,")"))   
    }
  }
  # plotting test_results <end>
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
  test_results=array();
  observed_jump=array();
  for ( i in seq(length(date_vector))) {
    # use different functions for different signal calculation criteria
    
    status = get_vol_signal_at_last_point(date_vector=date_vector[1:(i-1)],price_vector=price_vector[1:(i-1)],tol=tol);
    signals[i]=status$signal;
    # populating test_results<START>
    if (i>1){
      test_results[i]=(status$vector);
      observed_jump[i] = price_vector[i]-price_vector[i-1];
      # populating test_results<END>
    }
    #print(paste("signal for ",date_vector[i], " was ", signals[i], " price today: ",price_vector[i]));
    
  }
  par(mfrow=c(2,1))
  
  plot(date_vector,test_results)
  plot(date_vector,observed_jump)
  stop("FINISHED generating DATA")
  return(signals);
  
}
