#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function wcc_countdown () {
  if [ -n "$CTD" ]; then
    [ -z "$UNUSED_SETTINGS" ] || return 4$(
      echo 'E: Flinching from auto-countdown due to unsupported settings!' >&2)
  else
    echo 'A few seconds after you answered this question,' \
      'WCC will assume your input focus is in the "World Name"' \
      'field of the "Create New World" dialog.' \
      'How many seconds will you need to prepare that?'
    echo -n 'Enter a positive number, or "0" to abort: '
    read -r CTD || return $?
    [ "${CTD:-0}" -ge 1 ] || return 4$(echo 'E: Aborted by user.' >&2)
  fi
  echo -n 'Count-down! '
  for CTD in $(seq "$CTD" -1 1); do
    echo -n "$CTD… "
    sleep 1s || return $?
  done
  echo 'Engage!'
}







return 0
