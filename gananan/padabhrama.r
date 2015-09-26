orderImbalance <- function (asksizes,bidsizes) {
    nlevels <- 5
    obImb = array();
    for (iLevel in seq(nlevels)) {
        log_ask_bid = log(cumsum(asksizes[1:iLevel]) / cumsum(bidsizes[1:iLevel]));
        vsizes = asksizes[1:iLevel] + bidsizes[1:iLevel];
        obImb[iLevel] = sum(log_ask_bid * vsizes) / sum(vsizes);
    }
    return (mean(obImb));
}
