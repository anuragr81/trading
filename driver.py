#!/usr/bin/python


import subprocess,sys,os,csv;
import datetime,time,calendar;

from recordprice import gettickerprice;
from array import SortedArray;
import window;
import portfolio;


class UTC(datetime.tzinfo):
   def utcoffset(self, dt):
       return datetime.timedelta(0)
   def tzname(self, dt):
       return "UTC"
   def dst(self, dt):
       return datetime.timedelta(0)

def tickerFileName(ticker): 
    return "data/"+ticker.strip()+".csv"
    
def lastMinuteSeconds(seconds,utc): 
     timeNow = time.gmtime(seconds)
     return calendar.timegm(datetime.datetime(timeNow.tm_year,timeNow.tm_mon,timeNow.tm_mday,timeNow.tm_hour,timeNow.tm_min,0,0,utc).timetuple())

def midnightSeconds(year,month,mday,utc) : 
     return calendar.timegm(datetime.datetime(year,month,mday,0,0,0,0,utc).timetuple())
     
def sync_prices(ticker,prices,utc):
    print "sync_prices: size(array)=",len(prices.arraydict)
    ticker=ticker.strip()
    curLastMinute =lastMinuteSeconds(time.time(),utc) 
    reload_flag = False
    if os.path.exists(tickerFileName(ticker)) : 
       lm = lastMinuteSeconds(os.path.getmtime(tickerFileName(ticker)),utc)
       print "CurLastMinute=",curLastMinute, "  FileLastMinute=",lm
       if curLastMinute > lm : 
          reload_flag = True
       else : 
          print "Price already recent for current minute."
    else : 
       reload_flag = True

    if reload_flag :
        filename="/tmp/data."+ticker
        subprocess.call(["./loadminutedata.sh",ticker,filename])
        price = gettickerprice(ticker,filename)
        if  price != None : 
	      prices.addRow([curLastMinute , price])
              print "sync_prices 2 : size(array)=",len(prices.arraydict)
        subprocess.call(["./cleanupminutedata.sh",filename]); 

def reloadWebData(tickerfile) : 
     utc = UTC()
     ticker_prices=dict()
     tickers=open(tickerfile).readlines()
     for t in tickers : 
          t=t.strip()
          ticker_prices[t]=SortedArray(0)
          if os.path.exists(tickerFileName(t)) :
             #load price snapshot matrix
             ticker_prices[t].load(tickerFileName(t))

          print "reloadWeb: size(array)=",len(ticker_prices[t].arraydict)
          sync_prices(t,ticker_prices[t],utc)
          print ticker_prices[t].dump()
          ticker_prices[t].save(tickerFileName(t))
     return ticker_prices

def loadDataFromFile(tickerlist): 
     tickers=open(tickerlist).readlines()
     ticker_prices=dict()
     for t in tickers : 
          t=t.strip()
          ticker_prices[t]=SortedArray(0)
	  ticker_prices[t].load(tickerFileName(t))
     return ticker_prices    

def tickerHistCSVName(ticker): 
    return "data/"+ticker.strip()+".html"

# gets second col
def getHighsFromHistFile(histfile): 
    # Must return Array instance
    wr = csv.reader(open(histfile,"r"),quotechar='|',quoting=csv.QUOTE_MINIMAL)
    outArr = SortedArray(0)
    count = 0 
    for row in wr : 
       if count > 0 :  # skipping first entry
         cur_time = calendar.timegm(time.strptime(row[0],"%Y-%m-%d"))
         outArr.addRow([cur_time, row[2]]);  
       else : 
         count = count + 1
    return outArr

# gets third col
def getLowsFromHistFile(histfile): 
    # Must return Array instance
    wr = csv.reader(open(histfile,"r"),quotechar='|',quoting=csv.QUOTE_MINIMAL)
    outArr = SortedArray(0)
    count = 0 
    for row in wr : 
       if count > 0 : 
          cur_time = calendar.timegm(time.strptime(row[0],"%Y-%m-%d"))
          outArr.addRow([cur_time, row[3]]);
       else : 
          count = count + 1
    return outArr


def readHistoricalPricesFile(tickerfile) : 
     tickers=open(tickerfile).readlines()
     highs=dict()
     lows=dict()
     for t in tickers : 
         t=t.strip() 
	 fname=tickerHistCSVName(t)
	 highs[t]=SortedArray(0)
         if os.path.exists(fname): 
	    highs[t]=getHighsFromHistFile(fname)
	    lows[t]=getLowsFromHistFile(fname)
     return [ highs, lows ] 

TICKERFILE = "tickers.lst"
#ticker_prices = reloadWebData(TICKERFILE)

#
# 1. Criteria of alert is only a "sudden-down" in prices. For now it means lowering of the 3-month range.
# 2. For now it historical prices would be used for the 3 month prices.
#    Use of historical prices in determining averages is also better due to optimization reasons.
#

#period_range();

#ticker_prices = loadDataFromFile(TICKERFILE)
#for t in ticker_prices.keys() : 
   #print ticker_prices[t].dump()

(lows,highs) = readHistoricalPricesFile(TICKERFILE)
csco_arr = lows['CSCO'] 

#csco_arr = SortedArray(0);
#csco_arr.load("/tmp/CSCOFILE");

wop = window.WindowOperator(csco_arr)
wd = window.WopDict()
wd.wopdict['CSCO']=wop

start_time  = calendar.timegm(datetime.datetime(2011,12,1,0,0,0,0,UTC()).timetuple())
end_time = time.time()

#print "Max=",window.window_max(lows['CSCO'],[ start_time , end_time ] )

p = portfolio.Portfolio(86400)
p.tickers['CSCO']=2

print p.evaluate(start_time,wd)
print wop.window_max([start_time,end_time])
print wop.window_min([start_time,end_time])
