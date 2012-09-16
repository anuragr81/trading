# Instead of thinking of buying or selling it is better to think in terms of current portfolio vs portfolio. In real-life it is really the portfolio we're trying to move.

import window;

class Portfolio:
  def __init__(self):
     self.tickers=dict()

  def trade(self,ticker,qty): # +;- :: buy;sell
     if ticker in self.tickers.keys() : 
       self.tickers[ticker]=self.tickers[ticker]+qty

  def evaluate(self,time,windowcalc): 
      sum = 0
      for tkr in self.tickers.keys(): 
         closest_time = windowcalc.closest_time(time);
         price = float(windowcalc[closest_time][0])
         sum = sum + price*self.tickers[tkr]
      return sum
