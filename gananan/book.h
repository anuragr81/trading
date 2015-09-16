
class ArmaTradeBook
{
public:

    DEFINE_GETTER_SETTER(int, pagi)
    DEFINE_GETTER_SETTER(double, price)
    DEFINE_GETTER_SETTER(int, size)
    DEFINE_GETTER_SETTER(int, aggsize)
    DEFINE_GETTER_SETTER(int64_t, symbolSequenceNumber)
    DEFINE_GETTER_SETTER(int64_t, timeExchange)
    DEFINE_GETTER_SETTER(int64_t, timeLocal)

};


class ArmaOrderBook
{
public:

    DEFINE_GETTER_SETTER(size_t, levels)
    DEFINE_GETTER_SETTER(rowvec, vecBid)
    DEFINE_GETTER_SETTER(rowvec, vecAsk)
    DEFINE_GETTER_SETTER(rowvec, vecBidSize) // double is needed for comparison with repeat threshold
    DEFINE_GETTER_SETTER(rowvec, vecAskSize) // double is needed for comparison with repeat threshold
    DEFINE_GETTER_SETTER(rowvec, vecBidOrdCount) // double is needed for comparison with repeat threshold
    DEFINE_GETTER_SETTER(rowvec, vecAskOrdCount) // double is needed for comparison with repeat threshold
    DEFINE_GETTER_SETTER(int64_t, timeExchange)
    DEFINE_GETTER_SETTER(int64_t, timeLocal)
    DEFINE_GETTER_SETTER(int64_t, symbolSeqNum)

};

#endif
