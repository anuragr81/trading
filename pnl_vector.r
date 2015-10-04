
num_to_buy <- function(cost,cost_limit,price){
  num = (cost_limit - cost)/price;
  print(paste("cost_limit=",cost_limit," cost=",cost," num=",num));
  if (num>0){
    if (num>=1){
      return(floor(num));
    } else {
      return(0);
    }
  } else {
    stop("Already hit (buy) cost_limit");
  }
}

# @desc - cautious sell for liquid instruments - attempts only to
#         short everything only if profit can be made 
num_to_sell <- function (num_stocks,cost,price){
  if (num_stocks>0){
    # if we have more than one stock and cost limit won't be breached
    projected_cost = cost - num_stocks*price;
    print(paste("projected_cost(",projected_cost,")=cost(",cost,")-num_stocks(",num_stocks,")*price(",price,")"))
    if (projected_cost<0){
      # sell all owned stocks
      return(num_stocks);
    } else {
      # or sell nothing
      return (0);
    }
    
  } else {
    return(0);
  }
}


updateStash <- function (stash,cost,num_stocks)
{
  if (num_stocks==0){
    if (cost<0){
      # empty cost into stash
      stash = stash - cost;
      cost = 0 ;
    }
  }
  return (list(cost=cost,stash=stash));
  
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
  # update num_stocks and cost
  cost = 0;
  cost_limit = position_limit ; # interprets position_limit as cost_limit
  num_stocks = 0;
  stash=0;
  profit=array();
  for (i in seq(length(date_vector))){
    signal <- signals[i];
    stash_update = updateStash(stash=stash,cost=cost,num_stocks=num_stocks);
    stash = stash_update$stash;
    cost = stash_update$cost;
    profit[i]=stash;
    
    if (signal == 1){
      # buy
      n = num_to_buy(cost=cost,cost_limit=cost_limit,price=price_vector[i]);
      num_stocks = num_stocks + n ; # the only way num_stocks increases
      cost = cost + price_vector[i]*n;
      print(date_vector[i])
      print(paste("stash=",stash," num_stocks=",num_stocks, " signal=",signal," cost=",cost," traded=",n," price=",price_vector[i]));
    } else if (signal == -1)
    {
      # sell
      # when we are selling we don't need to worry about the number of units to be bought being a whole number
      n = num_to_sell(num_stocks = num_stocks, cost=cost,price=price_vector[i]);
      num_stocks = num_stocks -n;
      cost = cost - price_vector[i]*n;
      print(date_vector[i])
      print(paste("stash=",stash," num_stocks=",num_stocks," signal=",signal," cost=",cost," traded=",n," price=",price_vector[i]));
    }
    else if (signal ==0){
      print(paste("signal=",signal," traded=",0));
      # do nothing
    } else{
      stop("Error in signal");
    }
  }
  
  return(profit);
}


