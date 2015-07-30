
#include "TradeImbalance.h"

#include "utils/logging_util.h"
#include "packetfilters/TickRuleFilter.hpp"

alphas::PaidGivenResult alphas::tickRule(int instrument,
        processor::TickRuleFilter const & trp,
        boost::shared_ptr<ArmaTradeBook> const & tb,
        generated_settings::c_settings const & settings) {

    static log4cxx::LoggerPtr logger(log4cxx::Logger::getLogger("alphas.TradeSizeImbalance"));

    if (tb->pagi() == 0) {

        std::pair<bool, ArmaTradeBook> lastCompleteBook = trp.getZeroPagiTick(instrument);
        if (lastCompleteBook.first) {
            // the queue already has added the last packet with mid1<>tb->price
            // hence use pagi value from the last completed tick
            if (lastCompleteBook.second.pagi() == 1) {
                //return PaidGivenResult(tradeimbalance::PAID, tb->size());
                return PaidGivenResult(tradeimbalance::PAID, tb->aggsize());
            } else if (lastCompleteBook.second.pagi() == -1) {
                return PaidGivenResult(tradeimbalance::GIVEN, tb->aggsize());
            }
        } else {
            LOG4CXX_ERROR(logger, "No TR tick found for trade snumer" << tb->symbolSequenceNumber())
        }
    } else if (tb->pagi() == 1) {
        //return PaidGivenResult(tradeimbalance::PAID, tb->size());
        return PaidGivenResult(tradeimbalance::PAID, tb->aggsize());
    } else if (tb->pagi() == -1) {
        //return PaidGivenResult(tradeimbalance::GIVEN, tb->size());
        return PaidGivenResult(tradeimbalance::GIVEN, tb->aggsize());
    } else {
        LOG4CXX_ERROR(logger, "Invalid Pagi for trade snumber" << tb->symbolSequenceNumber())
    }

    return PaidGivenResult(tradeimbalance::NONE, 0);
}

double alphas::calculateAlphaForPaid(double paid, boost::shared_ptr<ArmaTradeBook> const & tb,
        generated_settings::c_settings const & settings) {
    static log4cxx::LoggerPtr logger(log4cxx::Logger::getLogger("alphas.TradeSizeImbalance"));

    double sizes = paid;
    // treat small sizes as unitary
    if (arma_utils::isLessThan(std::abs(sizes), 1)) {
        sizes = 1;
    }

    sizes = arma_utils::signum(sizes) * log(std::abs(sizes));

    LOG4CXX_DEBUG(logger, "snumber:" << tb->symbolSequenceNumber() << "," << tb->aggsize() << "," << sizes)
    return sizes;
}

double alphas::calculateAlphaForGiven(double given, boost::shared_ptr<ArmaTradeBook> const & tb,
        generated_settings::c_settings const & settings) {
    static log4cxx::LoggerPtr logger(log4cxx::Logger::getLogger("alphas.TradeSizeImbalance"));

    double sizes = -given;
    // treat small sizes as unitary
    if (arma_utils::isLessThan(std::abs(sizes), 1)) {
        sizes = 1;
    }

    sizes = arma_utils::signum(sizes) * log(std::abs(sizes));

    LOG4CXX_DEBUG(logger, "snumber:" << tb->symbolSequenceNumber() << "," << tb->aggsize() << "," << sizes)
    return sizes;
}

double alphas::calculateTradeImbalanceAlpha(int instrument,
        processor::TickRuleFilter const & trp,
        boost::shared_ptr<ArmaTradeBook> const & tb,
        generated_settings::c_settings const & settings) {

    static log4cxx::LoggerPtr logger(log4cxx::Logger::getLogger("alphas.TradeSizeImbalance"));

    alphas::PaidGivenResult pgData = tickRule(instrument, trp, tb, settings);

    // paid and given are mutually exclusive

    if (pgData.value().first == tradeimbalance::GIVEN) {
        return calculateAlphaForGiven(pgData.value().second, tb, settings);
    } else if (pgData.value().first == tradeimbalance::PAID) {
        return calculateAlphaForPaid(pgData.value().second, tb, settings);
    }

    return 0;
}

namespace processor
{

    class TickRuleFilter : boost::noncopyable
    {
    public:

        TickRuleFilter(common_types::MarketInstrumentsIdMap const & idMap) :
        {
            using namespace std;

            for (map<string, int>::const_iterator itInstr = idMap.getInstrumentsIdMap().begin();
                    itInstr != idMap.getInstrumentsIdMap().end(); ++itInstr) {
                _queueZeroPagiMidPrices.insert(std::pair<int, TQueueTradeBook>(itInstr->second, TQueueTradeBook()));
            }
        }

        std::pair<bool, ArmaTradeBook> getZeroPagiTick(int instrument) const
        {
            if (_queueZeroPagiMidPrices.at(instrument).size()) {
                return std::pair <bool, ArmaTradeBook > (true, _queueZeroPagiMidPrices.at(instrument).back());
            }
            else {
                return std::pair <bool, ArmaTradeBook > (false, ArmaTradeBook());
            }
        }

        void updateZeroPagiQueue(int instrument, boost::shared_ptr<ArmaOrderBook> const & ob,
                                 boost::shared_ptr<ArmaTradeBook> const & tb)
        {

            // comparison with mid is only required when pagi is zero
            // otherwise queue is never needed - the queue is thus
            // updated only when pagi == 0

            std::map<int, std::deque<ArmaTradeBook> >::iterator index = _queueZeroPagiMidPrices.find(instrument);
            if (index == _queueZeroPagiMidPrices.end()) {
                LOG4CXX_ERROR(_logger, "error: no queue for instrument: " << instrument)
                return;
            }

            std::deque<ArmaTradeBook> & queuemidPrice = index->second;

            if (tb->pagi() != 0) {
                return;
            }
            else {

                // tb.pagi is 0

                double mid1 = 0.5 * (ob->vecBid()(0) + ob->vecAsk()(0));

                if (queuemidPrice.size() > 0) {

                    // there is queued tb - update with newTb
                    // if the tb.price is greater or less than current mid1
                    // (i.e. complete the tick)
                    if (arma_utils::isGreaterThan(tb->price(), mid1)) {
                        ArmaTradeBook newTb(*tb);
                        newTb.pagi() = 1;
                        queuemidPrice.push_back(newTb);
                        queuemidPrice.pop_front();
                    }

                    else if (arma_utils::isLessThan(tb->price(), mid1)) {
                        ArmaTradeBook newTb(*tb);
                        newTb.pagi() = -1;
                        queuemidPrice.push_back(newTb);
                        queuemidPrice.pop_front();
                    }

                    // if mid1== tb.price then leave the queue as it is so that later tickRule
                    // invocations use the last element in the queue
                    // this essentially implements "going backwards"
                }
                else {

                    // queue is empty perform the check and add to queue

                    if (arma_utils::isGreaterThan(tb->price(), mid1)) {
                        ArmaTradeBook newTb(*tb);
                        newTb.pagi() = 1;
                        queuemidPrice.push_back(newTb);
                    }

                    else if (arma_utils::isLessThan(tb->price(), mid1)) {
                        ArmaTradeBook newTb(*tb);
                        newTb.pagi() = -1;
                        queuemidPrice.push_back(newTb);
                    }
                    else {
                        if (randu() > .5) {
                            ArmaTradeBook newTb(*tb);
                            newTb.pagi() = 1;
                            queuemidPrice.push_back(newTb);
                        }
                        else {
                            ArmaTradeBook newTb(*tb);
                            newTb.pagi() = -1;
                            queuemidPrice.push_back(newTb);
                        }
                    }
                }
            } // end pagi == 0 check
        }
    private:
        typedef std::deque<ArmaTradeBook> TQueueTradeBook;
        std::map<int, std::deque<ArmaTradeBook> > _queueZeroPagiMidPrices;

    };
}


