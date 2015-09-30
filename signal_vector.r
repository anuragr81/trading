
is.POSIXlt <- function(x) inherits(x, "POSIXlt")

# @desc          - returns signal using ALL data provided
# @preconditions - assumes date_vector and price_vector are of same length
get_signal_at_last_point <- function(date_vector,price_vector,position) {
  n <- length(price_vector);
  if (n>10) {
    print(paste("moving average=",mean(price_vector[n-5:n])));
    print(paste("last_price=",price_vector[n]));
    dat<-data.frame(date=date_vector,price=price_vector);
    if (price_vector[n]<mean(price_vector[n-5:n])) { # if price hits below mean-average then buy
       print(paste("Buying on ",date_vector[n]," at ",price_vector[n]));
    }
    if(n==20){
    print(dat);
    plot(dat$date,dat$price);
    stop("Done");
    }
  }
  
  return(list(signal_value=length(date_vector),position=position));
}

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
  for ( i in seq(length(date_vector))) {
    # use different functions for different signal calculation criteria
    signal_status = get_signal_at_last_point(date_vector[1:i],price_vector[1:i],position);
    signals[i]=signal_status$signal_value
    position <- signal_status$position;
    print(paste("position=",position))
    
  }
  print(signals);

}
