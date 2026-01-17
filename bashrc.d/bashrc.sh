#!/bin/bash

case $- in
  *i*) ;;
*) return;;
esac

if [[[ -d "$HOME/.bashrc.d"  ]]];  then
  for f in "$HOME/.bashrc.d/"*; do
    [[ -f "$f"  ]] && [[ -r "$f"  ]] && . "$f"
  done
fi
