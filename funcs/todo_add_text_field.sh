#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function todo_add_text_field () {
  local KEY="$1"
  local BUF='Down Ctrl+a Delete'
  if [ "${KEY:0:1}" == '¹' ]; then
    KEY="${KEY:1}"
    BUF="${BUF#* }"
  fi
  todo_add "Clear old $KEY >> key $BUF"
  eval "$(easycfg_to_local_var "VAL=$KEY")"
  todo_add "Type new $KEY >> type $VAL"
}







return 0
