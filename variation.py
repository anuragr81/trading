
def compute_win_bounds(self,window):
     for i_h in sorted(self.daily_highs.keys()) :
        day=0
        while day <= window  :
          sought_date=i_h+datetime.timedelta(day);
          effective_next_date=next_date_in_map(self.daily_highs,sought_date)
          if effective_next_date is not None and effective_next_date in self.daily_lows and i_h in self.daily_lows :
             ############HIGHS###################
             if i_h not in self.window_highs :
               self.window_highs[i_h]= daily_highs[i_h];
             else :
               if self.window_highs[i_h] < self.daily_highs[effective_next_date] :
                  self.window_highs[i_h]=self.daily_highs[effective_next_date];

             ############LOWS####################
             if i_h not in self.window_lows:
               self.window_lows[i_h]=daily_lows[i_h]
             else :
               if self.window_lows[i_h] > self.daily_lows[effective_next_date]:
                  self.window_lows[i_h]=self.daily_lows[effective_next_date];

             self.moving_range[i_h]=float(self.window_highs[i_h])  -  float(self.window_lows[i_h]);
          else :
             print "Ignoring date"+str(effective_next_date)
          day=day+1


def window_max(sarray, start_end ) : 
   start = start_end[0]
   end   = start_end[1]
   sorted_keys= sorted(sarray.arraydict.keys()) # sarray's keys have to be time
   # TODO: think of a way to verity that arraydict's keys are time -- 
   return 1
