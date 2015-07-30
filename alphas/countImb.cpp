
double alphas::calculateCountImbalanceAlpha(boost::shared_ptr<ArmaOrderBook> const & ob,
        generated_settings::c_settings const & settings) {

    rowvec cpImb(ob->levels());
    for (size_t iLevel = 0; iLevel < ob->levels(); ++iLevel) {
        cpImb(iLevel) = arma_utils::signedLogTransform(
                sum(ob->vecBidOrdCount()(span(0, iLevel)) - ob->vecAskOrdCount()(span(0, iLevel)))
                );
    }

    return (mean(cpImb));
}
