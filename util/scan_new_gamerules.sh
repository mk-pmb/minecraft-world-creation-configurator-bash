#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function sng_cli_main () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?

  local GR_LIST_CACHE="tmp.gamerules.$(date +%y%m%d).html"
  local GR_DFLT='tmp.gamerules.defaults.tsv'
  local GR_NAMES=()
  ensure_obtain_gamerule_data || return $?

  local MC_VER_IMPL=
  local FAILS=0
  for MC_VER_IMPL in ../funcs/mc_*.sh; do
    check_one_mcver "$MC_VER_IMPL" || (( FAILS += 1 ))
  done
  return "$FAILS"
}


function ensure_obtain_gamerule_data () {
  cache-file-wget "$GR_LIST_CACHE" \
    -- 'https://minecraft.fandom.com/wiki/Game_rule' || return $?
  <"$GR_LIST_CACHE" tr -s '\r\n' '\n' | tr -s ' \t' ' ' \
    | grep -Pe '<th\b[^<>]*>Rule name' -A 9009009 \
    | grep -m 1 -Fe '</table>' -B 9009009 \
    | tr '\n' '\r' | sed -rf <(echo '
      s~\r(</|<td)~\1~g
      ') \
    | tr '\r' '\n' \
    | sed -rf <(echo '
      s~(<[a-z]+) [^<>]*>~\1>~g
      s~</td>~\t~g
      s~</?(table|thead|tbody|tr|td|code|sup|span|i|a|br)>~~g
      ') \
    | cut -sf 1,3 | sort --version-sort >"$GR_DFLT" || return $?
  readarray -t GR_NAMES < <(cut -sf 1 -- "$GR_DFLT") || return $?
  echo "D: Found ${#GR_NAMES[@]} gamerule names total."
}


function check_one_mcver () {
  local VER_FILE="$1"
  echo -n "D: check $(basename -- "$VER_FILE"): "
  local VER_TEXT="$(cat -- "$VER_FILE")"
  local ITEM=
  local HAVE=() MISS=()
  for ITEM in "${GR_NAMES[@]}"; do
    case "$VER_TEXT" in
      *" $ITEM "* ) HAVE+=( "$ITEM" );;
      * ) MISS+=( "$ITEM" );;
    esac
  done
  local N_HAVE="${#HAVE[@]}"
  local N_MISS="${#MISS[@]}"
  if [ "$N_MISS" == 0 ]; then
    echo "found all $N_HAVE."
    return 0
  fi
  echo "found $N_HAVE but $N_MISS are not mentioned: ${MISS[*]}" >&2
  return 3
}











sng_cli_main "$@"; exit $?
