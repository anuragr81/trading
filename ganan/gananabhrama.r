signedLogTransform <- function(x){
   data = x ;
   if (abs(x) < 1) {
     data = 1;
   }
   return (sign(data)*log(abs(data)));
}

cpImbalance <- function(bidordcount,askordcount) {
    # ob is the book structure (made with vectors)
    cpImb=array();
    for (iLevel in seq(5)) {
        cpImb[iLevel] = signedLogTransform(sum(bidordcount[1:iLevel] - askordcount[1:iLevel]));
    }
    return (mean(cpImb));
}

~