import getopt,re,sys


# For programmatic executions one would
# worry about concurrency issues since the 
# communication between price reader
# and simulation is based on file-writing
# but since we're fetching prices
# for informational / alerting purposes it 
# does not matter if the prices are a few seconds stale.

def gettickerprice ( ticker ,wfile ) : 
    input = open(wfile).read();
    pattern=re.compile("id=\"yfs_l84_" + ticker.lower() + "\">([0-9]+\.[0-9]+)([^\/]*)</span>")
    res = re.search(pattern,input) 
    if res : 
       return res.group(1)
    else : 
       return None;

class ConfigParser  : 

    def __init__(self,input): 
      self.act_on_options = { 't': self.update_ticker,
                'f': self.update_file
                }

      options, remainder = getopt.getopt(sys.argv[1:], 'f:t:')
      for opt, arg in options :
        self.act_on_options[opt.replace('-','')](arg.replace('-',''))

    def update_ticker (self,t ) :
      self.ticker = t ;

    def update_file(self,f) :
      self.wfile = f

#config = ConfigParser(sys.argv[1]) 
#print gettickerprice(config.ticker,config.wfile);
