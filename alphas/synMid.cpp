


/*
 *
 *
 * @description   - calculates synthetic mid-alpha
 *
 * @preconditions - 1. The OrderBook is sorted:
 *                  1.1 Bid Rates in strictly decreasing order
 *                  1.2 Ask Rates in strictly increasing order
 *
 */

double alphas::calculateSynMidAlpha(boost::shared_ptr<ArmaOrderBook> const & ob,
        generated_settings::c_settings const & settings) {

    rowvec vals(ob->levels());

    double rho = settings.get_Alpha().get_MidDecay().get_double().get_value();

    double mid = .5 * (ob->vecBid()(0) + ob->vecAsk()(0));


    rowvec const & vecbids = fliplr(ob->vecBid());
    rowvec const & vecasks = ob->vecAsk();
    rowvec const & vecbidszs = fliplr(ob->vecBidSize());

    rowvec const & vecaskszs = ob->vecAskSize();

    size_t nlevels = ob->levels();
    for (size_t iLevel = 1; iLevel <= ob->levels(); ++iLevel) {

        rowvec P = join_horiz(vecbids(span(nlevels - iLevel, nlevels - 1)), vecasks(span(0, iLevel - 1)));
        rowvec Q = join_horiz(vecbidszs(span(nlevels - iLevel, nlevels - 1)), vecaskszs(span(0, iLevel - 1)));

        if (arma_utils::isLessThan(rho, 1)) { // difference smaller than tol ignored
            mat matLevels = linspace<mat>(1, iLevel + 1, iLevel + 1);
            mat matRho_W;
            matRho_W = rho * matRho_W.ones(iLevel + 1, 1); // generates a column of rhos
            matRho_W = exp(log(matRho_W) % matLevels); // evaluates rho.^[1:levels]
            matRho_W.insert_rows(0, flipud(matRho_W));
            matRho_W = matRho_W / as_scalar(sum(matRho_W)); // normalization - nx1 matrix with n=2*nlevels
            inplace_trans(matRho_W); // converts 2*n size column into a row
            Q = matRho_W % Q; //Q_{1x2n} .* W'_{1x2n}
        }

        vals(iLevel - 1) = mid - as_scalar(sum(P % Q) / sum(Q, 1));
    }

    return (mean(vals));
}
