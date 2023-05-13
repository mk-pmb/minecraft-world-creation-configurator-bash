#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function todo_add_spaces_enum () {
  local KEY="$1"; shift
  eval "$(easycfg_to_local_var "VAL=$KEY")"
  if [ -z "$VAL" ]; then
    todo_add "Skip field $KEY >> key Down"
    return 0
  fi
  local OPT= BUF= ENUM=
  for OPT in $*; do
    if [ "$OPT" == "$VAL" ]; then
      todo_add "Set $KEY = $VAL >> key Down$BUF"
      return 0
    else
      ENUM+=" $OPT"
      BUF+=' space'
    fi
  done
  echo "E: Unsupported value '$VAL' for option '$KEY'!" \
    "Expected one of:$ENUM" >&2
  return 3
}






return 0
