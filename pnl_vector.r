num_to_transact <- function(position,position_limit,price){
  num = (position_limit - position)/price;
  print(paste("position_limit=",position_limit," position=",position," num=",num));
  if (num>=1){
    return(floor(num));
  } else if (num<=-1){
    return(-floor(abs(num)));
  } else {
    return(0);
  }
}

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
  position = 0;
  for (i in seq(length(date_vector))){
    signal <- signals[i];
    if (signal == 1){
      # buy
      n = num_to_transact(position=position,position_limit=position_limit,price=price_vector[i]);
      position = position + price_vector[i]*n;
      print(date_vector[i])
      print(paste("signal=",signal," position=",position," traded=",n," price=",price_vector[i]));
    } else if (signal == -1)
    {
      # sell
      # when we are selling we don't need to worry about the number of units to be bought being a whole number
      n = num_to_transact(position=position,position_limit=0,price=price_vector[i]);
      position = position + price_vector[i]*n;
      print(date_vector[i])
      print(paste("signal=",signal," position=",position," traded=",n," price=",price_vector[i]));
    }
    else if (signal ==0){
      print(paste("signal=",signal," traded=",0));
      # do nothing
    } else{
      stop("Error in signal");
    }
    pnl[i]=0;
  }
  
  return(0);
}


