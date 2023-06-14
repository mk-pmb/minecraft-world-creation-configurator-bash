#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function easycfg_read_args () {
  local INPUT=( "$@" ) ADD=()
  local LN= K= V=
  while [ "${#INPUT[@]}" -ge 1 ]; do
    LN="${INPUT[0]}"; INPUT=( "${INPUT[@]:1}" )
    LN="${LN%$'\r'}"
    case "$LN" in
      '#'* | \
      ';'* | \
      '' ) continue;;

      :=* )
        LN="${LN#*=}"
        ADD=()
        readarray -t ADD <"$LN" || return $(
          echo "E: $FUNCNAME: Failed to read $LN: rv=$?" >&2)
        INPUT+=( "${ADD[@]}" )
        ADD=()
        ;;

      .=* )
        LN="${LN#*=}"
        source -- "$LN" --source-config || return $(
          echo "E: $FUNCNAME: Failed to source $LN: rv=$?" >&2)
        ;;

      *=* )
        K="${LN%%=*}"
        K="${K// /}"
        V="${LN#*=}"
        V="${V# }"
        CFG["$K"]="$V";;

      * ) echo "E: Unsupported syntax: $LN" >&2; return 4;;
    esac
  done
}


function easycfg_to_local_var () {
  local KEY= VAL=
  for VAL in $*; do
    KEY="${VAL%%=*}"
    VAL="${VAL#*=}"
    printf 'local %s="${CFG[%s]}"\n' "$KEY" "$VAL"
    printf 'UNUSED_SETTINGS="${UNUSED_SETTINGS// %s / }"\n' "$VAL"
  done
}


function easycfg_ignore_settings () {
  local K=
  for K in "$@"; do
    UNUSED_SETTINGS="${UNUSED_SETTINGS// $K / }"
  done
}











[ "$1" == --lib ] && return 0; "$@"; exit $?
