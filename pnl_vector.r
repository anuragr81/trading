
get_pnl_vector <- function(date_vector,price_vector,signals,start_position,position_limit){
  
  if (!is.numeric(price_vector)) {
    stop("price_vector must be numeric");
  }
  if (!is.POSIXlt(date_vector)){
    stop("date_vector must be POSIXlt");
  }
  if (length(date_vector) != length(price_vector)){
    stop("date_vector and price_vector must be of the same size");
  }
  if (length(date_vector) != length(signals)){
    stop("date_vector and signals must be of the same size");
  }
  pnl=array();
  for (i in seq(len(date_vector))){
    signal <- signals[i];
    if (signal == 1){
      # buy
    } else if (signal == -1)
    {
      # sell
    }
    else if (signal ==0){
      # do nothing
    } else{
      stop("Error in signal");
    }
  }
  pnl[i]=0;
}
return(0);
}


