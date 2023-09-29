#!/bin/bash

mkdir -p data/external

cd data/external
rm -rf *.csv

currenteDate=$(echo "`date "+%F"`")

COUNTER=0
for OUTPUT in $(seq 10000)
do
    echo "$COUNTER, CUSTOMER$COUNTER, 50.0, $currenteDate" >> export.csv
    let COUNTER++
done
