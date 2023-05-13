#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function wcc_do_chain () {
  local CHAIN="$* , " TASK= ARG=
  while [ -n "$CHAIN" ]; do
    TASK="${CHAIN%% , *}"
    [ "$TASK" != "$CHAIN" ] || CHAIN=
    CHAIN="${CHAIN#* , }"
    CHAIN="${CHAIN# }"
    CHAIN="${CHAIN# }"
    ARG="${TASK#* }"
    [ "$ARG" != "$TASK" ] || ARG=
    TASK="${TASK%% *}"
    # printf '\t‹%s›' "$TASK" "$ARG"; echo
    case "$TASK" in
      '' | '#'* ) ;;
      type )
        xdotool $TASK "$ARG" || return $?
        sleep "$DELAY_TEXT" || return $?
        ;;
      sleep | \
      eval ) "$TASK" "$ARG" || return $?;;
      key | keyup | keydown )
        xdotool $TASK $ARG || return $?
        sleep "$DELAY_KEYS" || return $?
        ;;
      * ) echo "E: unsupported chain task: $TASK" >&2; return 4;;
    esac
  done
}













return 0
