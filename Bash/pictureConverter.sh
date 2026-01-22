#!/bin/bash

MAX_PIXELS=$((2000000))

shopt -s nocaseglob extglob
for f in *.+(jpeg) *.+(jpg); do
    [ -f "$f" ] || continue
    mv -n "$f" "${f%.*}.jpg"
done

for img in *.png *.PNG *.webp *.WEBP; do
    [ -f "$img" ] || continue
    jpg="${img%.*}.jpg"
    ffmpeg -y -i "$img" "$jpg"
    rm "$img"
done

for jpg in *.jpg *.JPG; do
    [ -f "$jpg" ] || continue
    read width height < <(ffprobe -v error -select_streams v:0 \
        -show_entries stream=width,height -of csv=p=0:s=x "$jpg")
    pixels=$((width * height))
    if [ $pixels -gt $MAX_PIXELS ]; then
        scale=$(echo "scale=6; sqrt($MAX_PIXELS/$pixels)" | bc -l)
        new_width=$(printf "%.0f" $(echo "$width * $scale" | bc -l))
        new_height=$(printf "%.0f" $(echo "$height * $scale" | bc -l))
        ffmpeg -y -i "$jpg" -vf "scale=$new_width:$new_height" "tmp_$jpg"
        mv "tmp_$jpg" "$jpg"
    fi
done

jpegoptim --max=90 --strip-all *.jpg *.JPG
