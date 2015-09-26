synmid <- function(rho,bidprices,askprices,bidsizes,asksizes) {
    # Make sure the inputs are vectors (not matrices/arrays)
    if ( !is.null(dim(bidprices))|| !is.null(dim(askprices)) || !is.null(dim(bidsizes)) || !is.null(dim(asksizes)) ){
         stop ("inputs must be vectors (not matrices/arrays)")
    }
    mid = .5 * (bidprices[1]+askprices[1])

    if (trace_flag == TRUE) {
        print (paste("bidprices=",toString(bidprices)))
        print (paste("askprices=",toString(askprices)))
        print (paste("bidsizes=",toString(bidsizes)))
        print (paste("asksizes=",toString(asksizes)))
        print (paste("rho=",toString(rho)))
    }

    vecbids = rev(bidprices)
    vecasks = askprices
    vecbidszs = rev(bidsizes)
    vecaskszs = asksizes
    nlevels = 5
    vals = array()

    for (iLevel in seq(nlevels) ) {

        P = c(vecbids[(nlevels - iLevel+1) : nlevels], vecasks[1: iLevel]);
        Q = c(vecbidszs[(nlevels - iLevel+1):nlevels], vecaskszs[1:iLevel]);

        if (rho< 1) { # difference smaller than tol ignored
            matRho_W = rep(rho,iLevel); # generates a column of rhos
            matRho_W = matRho_W^seq(iLevel); # evaluates rho.^[1:levels]
            matRho_W = c(rev(matRho_W),matRho_W)
            matRho_W = matRho_W / sum(matRho_W); # normalization - nx1 matrix with n=2*nlevels
            Q = matRho_W * Q; # Q_{1x2n} .* W'_{1x2n}
        }
        print(paste("P=",toString(P)))
        print(paste("Q=",toString(Q)))
        print(paste("P*Q=",toString(P*Q)))
        print(paste("mid=",mid))
        print(paste("sum(P*Q)/sum(Q)=",toString(sum(P*Q)/sum(Q))))

        vals[iLevel] = mid - (sum(P*Q) / sum(Q));
    }

    return (vals);

}