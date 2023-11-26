#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

function scrollshot () {
  local DEST_BASE="$1"; shift
  [ -n "$DEST_BASE" ] || printf -v DEST_BASE 'tmp.%(%y%m%d-%H%M%S)T.' -1

  local SCR_W= SCR_H=
  eval "$(xwininfo -root | sed -nre 's~^\s*(W|H)(idth|eight):\s*~SCR_\1=~p')"
  local RULES_WIDTH=500
  local CUT_TOP=30
  local CUT_BOTTOM=30
  local CUT_LEFT=$(( ( SCR_W - RULES_WIDTH ) / 2 ))
  local SHOT_H=$(( SCR_H - CUT_TOP - CUT_BOTTOM ))
  local AREA="$CUT_LEFT,$CUT_TOP,$RULES_WIDTH,$SHOT_H"

  echo -n 'Scrolling up… '
  xdotool keydown Up; sleep 5s; xdotool keyup Up
  echo -n 'should be enough. '

  local SHOT_NUM= DEST= HASH= PREV_HASH=
  for SHOT_NUM in {01..20}; do
    echo -n "$SHOT_NUM, "
    xdotool key Down{,,,,,,,,,}
    sleep 0.5s
    DEST="$DEST_BASE$SHOT_NUM.jpeg"
    scrot --silent --autoselect "$AREA" --overwrite -- "$DEST" || return $?
    HASH="$(md5sum --binary -- - <"$DEST")"
    [ -n "$HASH" ] || return 4$(echo "E: Failed to hash $DEST" >&2)
    if [ "$HASH" == "$PREV_HASH" ]; then
      echo 'hash did not change => probably done.'
      rm --verbose -- "$DEST" || return $?
      return 0
    fi
    PREV_HASH="$HASH"
  done
  echo done.
}

scrollshot "$@"; exit $?
