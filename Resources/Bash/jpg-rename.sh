#!/bin/bash

DIR="."

index=0
for jpg in $(ls "$DIR"/*.jpg | sort); do
    mv -i "$jpg" "$DIR/$index.jpg"
    index=$((index + 1))
done
