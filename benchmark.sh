#!/bin/bash

while true; do
  cat .gitcoin-nonce | tee -a benchmark.log
  git add benchmark.log
  git commit -m "Benchmark"
  ./gitcoin.sh > /dev/null
done
