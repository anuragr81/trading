#!/bin/bash

start_day=26
start_month=02
start_year=1990

end_day=`date +'%d'`
end_month=`date +'%m'`
end_year=`date +'%Y'`

cat tickers.lst | while read ticker ;
do
  #url="http://ichart.finance.yahoo.com/table.csv?s=$ticker&a=$start_month&b=$start_day&c=$start_year&d=$end_month&e=$end_day&f=$end_year&g=d&ignore=.csv"
  url="http://real-chart.finance.yahoo.com/table.csv?s=$ticker&a=$start_month&b=$start_day&c=$start_year&d=$end_month&e=$end_day&f=$end_year&g=d&ignore=.csv"
  bash fetch.sh $url data/$ticker.html
  echo $url
done

