#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function todo_add () { TODO+=( "$@" ); }


function todo_add_goto_next_tab () {
  # We long press rather than Ctrl+Tab because the tabs sometimes
  # remember their focussed field.
  todo_add_longpress_and_then 'Switch to tab "'"$1"'"' \
    Up 1 Right $2 || return $?
}


function todo_add_confirm_button () {
  todo_add_longpress_and_then "$1" Down 2 "$2 space $3" || return $?
}


function todo_add_skip_unsupp () {
  local D="$(head --bytes="$1" -- /dev/zero | tr '\0' x)"
  todo_add "Skip $1 unsupported options >> key${D//x/ Down}"
}









return 0
