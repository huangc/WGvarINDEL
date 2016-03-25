#!/usr/bin/env bash
# Aim: split sample-soap.contig into user-assigned pattern and number of files. This is to speed up blat process of samples \
# by spitting sample evenly into parts and run blat of sample parts in parallel.
# Usage: SAMPLE-split.sh sample k
# Author: Chun-Yuan Huang
# Last Update: 3/25/2016

set -eo pipefail

# sample is the sample-soap.contig file
sample=$1
# parts is the number of parts for sample splitting.
parts=$2

## split sample by CHUNKS
# -a N, --suffix-length=N: Use suffixes of length N (default 2)
# -d, --numeric-suffixes: Use numeric suffixes instead of alphabetic.
# -n CHUNKS, --number=CHUNKS: Generate CHUNKS output files.
# where CHUNKS may be:
# N: split into N files based on size of input
# K/N: output Kth of N to standard output
# l/N: split into N files without splitting lines
# l/K/N: output Kth of N to standard output without splitting lines
# r/N: like "l" but use round robin distribution r/K/N likewise but only output Kth of N to standard output

split -d -a 1 -n l/$parts $sample $sample.part

