num_to_buy <- function(position,position_limit,price){
  num = (position_limit - position)/price;
  print(paste("position_limit=",position_limit," position=",position," num=",num));
  if (num>0){
    if (num>=1){
      return(floor(num));
    } else {
      return(0);
    }
  } else {
    stop("Already hit (buy) position_limit");
  }
}

# @desc - cautious sell for liquid instruments - attempts to
#         short everything as long as PNL is positive
num_to_sell <- function (num_stocks,position,min_limit,price){
  if (num_stocks>0){
    # if we have more than one stock and position limit won't be breached
    projected_pnl = position - num_stocks*price;
    if (projected_pnl>min_limit){
      # sell all owned stocks
      return(num_stocks);
    } else {
      return (0);
    }
    
  } else {
    return(0);
  }
}


updateStash <- function (stash,position,num_stocks)
{
  if (num_stocks==0){
    if (position>0){
      # empty position into stash
      stash = stash + position;
      position = 0 ;
    }
  }
  return (list(position=position,stash=stash));
  
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
  # update num_stocks and position
  position = 0;
  num_stocks = 0;
  stash=0;
  for (i in seq(length(date_vector))){
    signal <- signals[i];
    stash_update = updateStash(stash=stash,position=position,num_stocks=num_stocks);
    stash = stash_update$stash;
    position = stash_update$position;
    if (signal == 1){
      # buy
      n = num_to_buy(position=position,position_limit=position_limit,price=price_vector[i]);
      num_stocks = num_stocks + n ; # the only way num_stocks increases
      position = position + price_vector[i]*n;
      print(date_vector[i])
      print(paste("stash=",stash," num_stocks=",num_stocks, " signal=",signal," position=",position," traded=",n," price=",price_vector[i]));
    } else if (signal == -1)
    {
      # sell
      # when we are selling we don't need to worry about the number of units to be bought being a whole number
      n = num_to_sell(num_stocks = num_stocks, position=position,min_limit=0,price=price_vector[i]);
      num_stocks = num_stocks -n;
      position = position - price_vector[i]*n;
      print(date_vector[i])
      print(paste("stash=",stash," num_stocks=",num_stocks," signal=",signal," position=",position," traded=",n," price=",price_vector[i]));
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


