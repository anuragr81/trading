# Instead of thinking of buying or selling it is better to think in terms of current portfolio vs portfolio. In real-life it is really the portfolio we're trying to move.

import window;


# Portfolio should not have market data in it in any case.

class PriceNotFoundException(Exception):
    pass

class Portfolio:
  def __init__(self,tol):
     self.tickers=dict()
     self.tolerance = tol

  def trade(self,ticker,qty): # +;- :: buy;sell
     if ticker in self.tickers.keys() : 
       self.tickers[ticker]=self.tickers[ticker]+qty


  def evaluate(self,time,wopdict): 
      sum = 0
      for tkr in self.tickers.keys(): 
         #print "time=",time
	 wop = wopdict[tkr]
         closest_time = wop.closest_time(time);
	 if time - closest_time > self.tolerance : 
	   raise PriceNotFoundException();
	 else : 
           price = float(wop[closest_time][0])
	   #print "Time =", closest_time, " Price=",price
           sum = sum + price*self.tickers[tkr]
      return sum
