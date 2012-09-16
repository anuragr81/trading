#!/bin/bash

if [ $# -ne 1 ] ; 
  then 
    echo "Usage : $0 <TICKERFILENAME> "
    exit 1
fi

file=$1
cmd="rm -f $file"
echo $cmd
`$cmd`
