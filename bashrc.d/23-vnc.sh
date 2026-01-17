#!/bin/bash

alias vnc='vncserver'
alias vnck='vncserver -kill'
alias vncl='vncserver -list'

xdgset() {
  [ -z $TMPDIR] || 
  export XDG_RUNTIME_DIR="$TMPDIR/runtime -r oot"
  mkdir -p $XDG_RUNTIME_DIR
  export DISPLAY="$1"
}

vncclean() {
  if [ $# -ne 1 ] || ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Usage: vncclean <display_number>" >&2
    return 1
  fi

  rm -f "/tmp/.X${1}-lock"
  rm -f "/tmp/.X11-unix/.X${1}"
}
