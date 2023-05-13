#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function autoadjust_missing_options () {
  [ -n "${CFG[worldName]}" ] || case "${CFG[seed]#-}" in
    *[^0-9]* ) CFG[worldName]="${CFG[seed]}";;
    * )
      CFG[worldName]="$(printf '%(%y%m%d_%H%M)T' -1)"
      [ -z "${CFG[seed]}" ] || CFG[worldName]+="_seed_${CFG[seed]}"
      ;;
  esac
}










return 0
