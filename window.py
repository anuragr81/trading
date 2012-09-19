class KeyNotFoundinSortedList(Exception):
    def __init__(self, value):
      self.value = value
    def __str__(self):
      return repr(self.value)

def bsearch( ll , start_end ,  x) : 
   start =  start_end [ 0 ] 
   end   =  start_end [ 1 ] 
   mid = (start+end)/2
   if start > end : 
       return mid;
   else : 
         if x < ll[mid]  :
	    #print "x(",x,") <  ll[mid=",mid,"] (",ll[mid],")"
            return bsearch(ll, [0, mid-1], x)  
         else: 
	    if x > ll[mid] : 
	       #print "x(",x,") >  ll[mid=",mid,"] (",ll[mid],")"
               return bsearch(ll, [ mid+1, end ], x)
	    else : 
	       return mid;

def binary_search(ll,x):
 ret = bsearch(ll,[ 0 , len(ll)-1] , x)
 #print " returning index=", ret, " value=",ll[ret], " after searching for ",x
 return ret

# TODO: think of a way to verity that arraydict's keys are time -- for now 
# only float check exists

class WopDict: 
   def __init__(self):
       self.wopdict=dict()
   def __getitem__(self,item):
       return self.wopdict[item]


class WindowOperator : 
   def __init__(self,sarray):
       self.sarray = sarray
       self.sortedtimekeys = sorted(sarray.arraydict.keys())

   def __getitem__(self,item):
       return self.sarray.arraydict[item]

   def closest_time(self,itime) :
       return self.sortedtimekeys[binary_search (self.sortedtimekeys,itime)]

   def window_max(self,start_end): 
       start = start_end[0]
       end   = start_end[1]
       i_wstart = binary_search (self.sortedtimekeys,start)      
       i_wend = binary_search(self.sortedtimekeys,end)
       # Pretty smart. eh?
       return max(map(self.sarray.arraydict.get,self.sortedtimekeys[i_wstart:i_wend+1]))

   def window_min(self,start_end): 
       start = start_end[0]
       end   = start_end[1]
       i_wstart = binary_search (self.sortedtimekeys,start)      
       i_wend = binary_search(self.sortedtimekeys,end)
       return min(map(self.sarray.arraydict.get,self.sortedtimekeys[i_wstart:i_wend+1]))

#ll = [ 1, 10,100 ]
#pos = binary_search(ll,0)
