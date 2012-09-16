# Instead of thinking of buying or selling it is better to think in terms of current portfolio vs portfolio. In real-life it is really the portfolio we're trying to move.

class Portfolio:
  def __init__(self):
     self.tickers=dict()

  def trade(self,ticker,qty): # +;- :: buy;sell
     if ticker in self.tickers.keys() : 
       self.tickers[ticker]=self.tickers[ticker]+qty

  def evaluate(self,time,prices): 
      sum = 0
      for tkr in self.tickers.keys(): 
        sum = sum + prices[tkr][time]*self.tickers[tkr]
      return sum
