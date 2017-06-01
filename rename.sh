#!/bin/bash

for file in data/*.png; do
  num=$(echo $file | sed 's/^.*_//;s/\.png//')
  exe=0
  if [ $num -lt 10 ]; then
    ofile=$(echo $file | sed "s/_.*\./_00${num}./")
    exe=1
  elif [ $num -lt 100 ]; then
    ofile=$(echo $file | sed "s/_.*\./_0${num}./")
    exe=1
  fi
  if [ $exe -eq 1 ]; then
    mv -v $file $ofile
  fi
done
