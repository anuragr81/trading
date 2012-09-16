# Note that the market object is a pretty big one - it has all prices for 
# for all times. One can choose to represent it as : 
# market[ticker][date]=price  

#2.1 One also needs to think what happens if prices don't exist for a market
# how do we skip an entry in the portfolio. Do we not evaluate the portfolio
# if market does not exist? What I think for now is that we should just not make any decision about the ticker that is missing. It doesn't make sense to crash the whole program because of one error. Throwing exceptions is hardly the right way to do that. I tend to prefer the explicit checking of return because that is more tightly coupled way of handling a response (there are no expcetion hierarchies - all errors are exceptions only as long as errors are represented through exceptions). Using Error/Response is a way to avoid this constraint (which of course is not a constraint if the an exception hierarchy is found to be useful).

#2.2 If one does use exceptions for 2.1 then it must also be guarnateed that exceptions don't escape a certain layer. I don't know of any explicit way of guaranteeing that. Usually any exceptions can escape. What can be guaranteed is that a certain type of an exception would be caught in a certain function. There is no abstraction higher than that of a function that the guarantee is applied to.

#2.3 The problem with the time-window implemented with timestamps as index has been that next expected timestamps don't always exist. One should be able to have a meaningful time-window even when timestamps don't exist throughtout every step in the window. 
#  For a window(t1,t2,t3), if t1 doesn't exist the max-min should be calculated out of t2 and t3 (other sum operations should also be calculated in a similar manner). When storing in a matrix, then it non-uniform time-intervals should retain the equivalent non-unfiorm distance in the matrix as well i.e.
# t1, t1+w, t1+4w - should be stored as t1,t1+w,{},{},t1+4w in a matrix. A One matrix should always correspond to a time-unit (Since the sparseness is not really as prevalent in this data one does not have to worry about space/optimization concerns).

#2.4 2.3 leaves two steps i) populating matrix according tto 2.3 and then running the criteria. The simple alert now for sudden jump in the window_range. 

#2.5 The most important part is the test-bed : which must provide the following parameters - i) Daily Market Value of the portfolio i.e. the amount of money that can be obtained by shorting the portfolio.

from portfolio import *; 

p = Portfolio();

def isProfitableTrade(portfolio,ticker,quantity,market,t):
    if portfolio.hasTicker(ticker) : 
      p_cur = Portfolio() 
      p_cur.initialize(portfolio); 
      p_cur.trade(ticker,quantity); # portfolio after potential trade
      if t in markets[ticker] : 
         old_value=portfolio.evaluate(markets[:][t])
         new_value=p_cur.evaluate(markets[:][t])
         if new_value > old_value : 
            return True;
      else:
         return None;  

def isPotentialTrade(market_col,t,window,tolerance):
       if t >= 1 : 
         range_cur=max(market_col[t,t+window]) - min(market_col[t,t+window])
         range_prev=max(market_col[t-1,t+window-1]) - min(market_col[t-1,t+window-1]);
         if ( range_prev !=0 ) : 
           delta= range_cur/range_prev-1;
           if delta > tolerance : 
            return True;
         return False;



