
double alphas::calculateOrderBookImalanaceAlpha(boost::shared_ptr<ArmaOrderBook> const & ob,
        generated_settings::c_settings const & settings) {
    rowvec obImb(ob->levels());
    for (size_t iLevel = 0; iLevel < ob->levels(); ++iLevel) {
        rowvec log_ask_bid = log(cumsum(ob->vecAskSize()(span(0, iLevel))) / cumsum(ob->vecBidSize()(span(0, iLevel))));
        rowvec vsizes = ob->vecAskSize()(span(0, iLevel)) + ob->vecBidSize()(span(0, iLevel));
        obImb(iLevel) = sum(log_ask_bid % vsizes) / sum(vsizes);
    }
    return mean(obImb);
}
