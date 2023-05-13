#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function wcc_mc_1_19_4 () {
  eval "$(easycfg_to_local_var '
    GAME_EDI=gameEdition
    GAME_VER=gameVersion
    ')"
  case "$GAME_EDI v$GAME_VER" in
    'java v1.19.4' ) ;;
    * ) REMAINING_AUTO_CONFIRMS="!Unsupported game edition "$(
      )"'$GAME_EDI' and/or version '$GAME_VER'";;
  esac

  todo_add_text_field ¹worldName || return $?
  todo_add_spaces_enum gameMode survival hardcore creative || return $?

  case "${CFG[gameMode]}:${CFG[difficulty]}" in
    hardcore: | \
    hardcore:hard ) ;;
    hardcore:* )
      echo "E: Difficulty for hardcore mode must be 'hard'!" >&2
      return 3;;
    * )
      todo_add_spaces_enum difficulty '
        normal
        hard
        peaceful
        easy
        ' || return $?
      ;;
  esac

  case "${CFG[gameMode]}:${CFG[allowCheats]}" in
    hardcore: | \
    hardcore:no ) ;;
    hardcore:* )
      echo "E: In hardcore mode, option 'allowCheats' must be 'no'!" >&2
      return 3;;
    survival:* ) todo_add_spaces_enum allowCheats no yes || return $?;;
    creative:* ) todo_add_spaces_enum allowCheats yes no || return $?;;
    *: ) ;;
    * )
      echo "E: Unknown default cheat setting for gameMode ${CFG[gameMode]}" >&2
      return 3;;
  esac

  todo_add_goto_next_tab World || return $?
  todo_add_spaces_enum worldType default || return $?
  todo_add_text_field seed || return $?
  todo_add_spaces_enum generateStructures yes no || return $?
  todo_add_spaces_enum bonusChest no yes || return $?

  todo_add_goto_next_tab More || return $?
  todo_add 'Open the game rules page >> key Down space'
  todo_add_skip_unsupp 7
  todo_add_spaces_enum keepInventory no yes || return $?
  todo_add_skip_unsupp 7
  todo_add_spaces_enum mobGriefing yes no || return $?
  todo_add_spaces_enum universalAnger no yes || return $?
  todo_add_spaces_enum doInsomnia yes no || return $?
  todo_add_skip_unsupp 4
  todo_add_spaces_enum blockExplosionDropDecay yes no || return $?
  todo_add_skip_unsupp 3
  todo_add_spaces_enum mobExplosionDropDecay yes no || return $?
  todo_add_spaces_enum tntExplosionDropDecay no yes || return $?
  todo_add_spaces_enum doDaylightCycle yes no || return $?
  todo_add_spaces_enum doFireTick yes no || return $?
  todo_add_spaces_enum doVinesSpread yes no || return $?
  todo_add_spaces_enum doWeatherCycle yes no || return $?
  todo_add_spaces_enum lavaSourceConversion no yes || return $?
  todo_add_confirm_button 'Confirm game rule changes' Left || return $?

  todo_add 'Open the experiments page >> key Down space'
  todo_add_spaces_enum expBundles no yes || return $?
  todo_add_spaces_enum expUpdateOneTwenty no yes || return $?
  todo_add 'Confirm experiments selection >> key Down Left space'
  todo_add 'Wait for experiments to be applied >> sleep 3'

  todo_add_confirm_button 'Confirm world creation' Left || return $?
}










return 0
