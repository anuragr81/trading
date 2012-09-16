#!/bin/bash

if [ $# -lt 1 ] ;
then
  echo "Usage. $0 <url>"
  exit 1
fi

if [ $# -eq 2 ] ;
then
      output_file=$2
else
      output_file=out.$$
fi

wget -q "$1" -O $output_file
