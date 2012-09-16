#!/bin/bash

start_day=26
start_month=02
start_year=1990

end_day=10
end_month=01
end_year=2012

cat tickers.lst | while read ticker ;
do
  url="http://ichart.finance.yahoo.com/table.csv?s=$ticker&a=$start_month&b=$start_day&c=$start_year&d=$end_month&e=$end_day&f=$end_year&g=d&ignore=.csv"
  ./fetch.sh $url data/$ticker.html
  echo $url
done

