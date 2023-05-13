#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function todo_add_longpress_and_then () {
  local DESCR="$1"; shift
  local BTN1="$1"; shift
  local DURA="$1"; shift
  local THEN="$1"; shift
  case "$DURA" in
    [1-9] ) ;;
    * )
      THEN="${FUNCNAME[*]:1}"
      echo "E: $FUNCNAME: Duration for '$DESCR' must be 1..9, not '$DURA'." \
        "Called from ${THEN// / <- }." >&2
      return 3;;
  esac
  [ -z "$THEN" ] || THEN=" , key $THEN"
  todo_add "$DESCR >> keydown $BTN1 , sleep $DURA , keyup $BTN1$THEN"
}










return 0
