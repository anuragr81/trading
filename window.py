class KeyNotFoundinSortedList(Exception):
    def __init__(self, value):
      self.value = value
    def __str__(self):
      return repr(self.value)

def bsearch( ll , start_end ,  x) : 
   start =  start_end [ 0 ] 
   end   =  start_end [ 1 ] 
   mid = (start+end)/2
   #print "start=",start," end=",end," mid=",mid   
   if start > end : 
       return mid;
   else : 
         if x < ll[mid]  :
            return bsearch(ll, [0, mid-1], x)  
         else: 
	    if x > ll[mid] : 
               return bsearch(ll, [ mid+1, end ], x)
	    else : 
	       return mid;

def binary_search(ll,x):
  return bsearch(ll,[ 0 , len(ll)-1] , x)

class WindowOperator : 
   def __init__(self,sarray):
       self.sarray = sarray
       self.sortedtimekeys = sarray.arraydict.keys()
   def window_max(self,start_end): 
       start = start_end[0]
       end   = start_end[1]
       i_wstart = binary_search (self.sortedtimekeys,start)      
       i_wend = binary_search(self.sortedtimekeys,end)
       # Pretty smart. eh?
       return max(map(self.sarray.arraydict.get,self.sortedtimekeys[i_wstart:i_wend+1]))
       
def window_max(sarray, start_end ) : 
   # sorted_timekeys= sorted(sarray.arraydict.keys()) # sarray's keys have to be time
   # TODO: think of a way to verity that arraydict's keys are time -- 
   w = WindowOperator(sarray)
   return  w.window_max(start_end)

#ll = [ 1, 10,100 ]
#pos = binary_search(ll,0)
