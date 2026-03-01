#!/bin/bash

DIR="."

for file in "$DIR"/*.[hH][eE][iI][cC]; do
    [ -e "$file" ] || continue
    filename="${file%.*}"
    heif-convert "$file" "${filename}.jpg"
done

rm *.[hH][eE][iI][cC]
