#!/bin/bash
for dir in */*/; do
  cd "$dir" || continue
  for tex_file in *.tex; do
    if [[ -f "$tex_file" ]]; then
      echo "Processing $tex_file in $dir"
      xelatex "$tex_file"
      xelatex "$tex_file"
      echo "Finished processing $tex_file. Press Enter to continue..."
      read
    else
      echo "No .tex files in $dir"
    fi
  done
  cd - || exit
done