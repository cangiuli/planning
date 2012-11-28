#!/bin/sh

N=${1:-100}

for I in `seq 0 $N`; do printf "p%d " $I; done; echo;
echo
for I in `seq 0 $N`; do printf "l%d " $I; done; echo;

echo

for I in `seq 0 $(expr $N - 1)`; do printf "(la l%d l%d) " $I $(expr $I + 1); done; echo
