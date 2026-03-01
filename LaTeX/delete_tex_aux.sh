#!/bin/bash
shopt -s nullglob
start_dir=$(pwd)
for dir in */; do
  cd "$dir" || continue
  rm -f *.aux *.log *.out *.toc
  cd "$start_dir" || exit
done
shopt -u nullglob