#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function wcc_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  # cd -- "$SELFPATH" || return $?
  source_these_libs "$SELFPATH"/funcs/*.sh || return $?

  local -A CFG=()
  easycfg_read_args :="$SELFPATH"/cfg.defaults.ini || return $?
  easycfg_read_args "$@" || return $?

  autoadjust_missing_options || return $?
  local UNUSED_SETTINGS=" $(easycfg_list_all_settings_names | tr '\n' ' ')"
  eval "$(easycfg_to_local_var '
    REMAINING_AUTO_CONFIRMS=autoConfirmInteractions
    ')"

  wcc_mc_1_19_4 || return $?
  wcc_engage || return $?
}


function source_in_func () { source -- "$@"; }


function source_these_libs () {
  local LIB=
  for LIB in "$@"; do
    source_in_func "$LIB" --lib || return $?
  done
}










wcc_cli_init "$@"; exit $?
