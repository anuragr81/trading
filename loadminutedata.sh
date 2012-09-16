#!/bin/bash

if [ $# -ne 2 ] ; 
  then 
    echo "Usage : $0 <TICKERNAME> <FILENAME> "
    exit 1
fi

ticker=$1
file=$2
url="http://finance.yahoo.com/q?s=$ticker"
./fetch.sh $url $file
# /tmp/tickerdata.$ticker
