import csv;

class InvalidAddRowException(Exception): 
    def __init__(self, value):
       self.value = value
    def __str__(self):
       return repr(self.value) 

class InvalidAddColException(Exception): 
    def __init__(self, value):
       self.value = value
    def __str__(self):
       return repr(self.value) 

class ArrayManip:
   def __init__(self,array,i,j):
     self.array=array
     self.i=i
     self.j=j

   def set(self,value):
     self.array[self.i][self.j]=value; 

   def get(self):
     return self.array[self.i][self.j]



# # SortedArray stores an unsorted dict with it's key
#   being the sortcol passed during the creation.
# # The sortcol is always the key and is excluded from the value
class SortedArray : 
  def __init__(self,sortcol): 
     self.arraydict = dict()
     self.sortcol = sortcol

  def addRow(self,row) :
    if len(self.arraydict) == 0 : 
       self.arraydict[row[self.sortcol]] = row[0:self.sortcol]+row[self.sortcol+1:]
       # self.firstkey=row[self.sortcol]
    else : 
       col_size=len(self.arraydict[self.arraydict.keys()[0]])+1
       if col_size != len(row) : 
          raise InvalidRowAddException(str(len(row)));
       else : 
          self.arraydict[row[self.sortcol]] = row[0:self.sortcol]+row[self.sortcol+1:] # no duplicate keys are possible

  def addCol(self,col): 
      if col == self.sortcol : 
         raise InvalidAddColException(col); # no key update supported
      else : 
        row_size=len(self.arraydict)
        if row_size != len(col) :
           raise InvalidAddColException(str(len(col)));
        else :
           i = 0 
           for key in sorted(self.arraydict.keys()) : 
                self.arraydict[key].append(col[i])
                i = i + 1
  
  def dump(self): 
      # sorted output
      ret=""
      for key in sorted(self.arraydict.keys()) :
         ret = ret + "\nkey="+str(key)+ ",value=["
         for j in range(0,len(self.arraydict[key])):
	     ret = ret + str(self.arraydict[key][j])+" "
	 ret = ret +  "]"
      return ret;

  def save(self,file): 
      wf = csv.writer(open(file,"w+"),quotechar='|',quoting=csv.QUOTE_MINIMAL)
      for key in sorted(self.arraydict.keys()):
          row = []
	  row.append(key) # first col is key
	  row=row+self.arraydict[key]
          wf.writerow(row)

  def load(self,file): 
      wr = csv.reader(open(file,"r"),quotechar='|',quoting=csv.QUOTE_MINIMAL)
      self.arraydict={}
      for row in wr: 
         self.arraydict[row[0]]=row[1:]



class Array : 
  def __init__(self):
     self.array = []

  def addRow(self,row): 
      if len(self.array) == 0 : 
         self.array.append(row) # first row (no el-check)
      else : 
         # check sizes
         col_size=len(self.array[0])
         if col_size != len(row) : 
          raise InvalidRowAddException(str(len(row)));
         else : 
          self.array.append(row); 

  def addCol(self,col):
      row_size=len(self.array)
      if row_size == 0 : 
         for i in range(0,row_size): 
            self.array.append([])
      else :       
         if row_size != len(col) :
            raise InvalidAddColException(str(len(col)));
         else :
            for i in range(0,row_size): 
                self.array[i].append(col[i])

  def value(self,i,j):
      am=ArrayManip(self.array,i,j);
      return am;

  def row(self,i) : 
      col=[]
      for j in range(0,len(self.array)): 
        col.append(self.array[i][j])
      return col;

  def rows(self) : 
      return self.array;

  def col(self,j): 
       row=[]
       print self.array[0] 
       for i in range(0,len(self.array)): 
           row.append(self.array[i][j])
       return row

  def cols(self): 
       cols = []
       for j in range(0,len(self.array[0])) : 
           cols.append(col(j))
       return cols

  def dump(self): 
      ret=""
      for i in range(0,len(self.array)) :
         ret = ret + "\n";
         for j in range(0,len(self.array[i])):
            ret = ret + "a("+str(i)+","+str(j)+")="+str(self.array[i][j])+"  "
      return ret;

  def save(self,file): 
      wf = csv.writer(open(file,"w+"),quotechar='|',quoting=csv.QUOTE_MINIMAL)
      for row in self.array:
          wf.writerow(row)

  def load(self,file): 
      wr = csv.reader(open(file,"r"),quotechar='|',quoting=csv.QUOTE_MINIMAL)
      self.array=[]
      for row in wr: 
          self.addRow(row)


#a = SortedArray(0)
#a.addRow([3,4])
#a.addRow([1,2])
#a.addCol([5,6])
#a.load("/tmp/test")
#print a.dump()
#a.save("/tmp/test")
