#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function wcc_engage () {
  echo 'Command preview:'
  printf '%s\n' "${TODO[@]}" | nl -ba
  echo

  eval "$(easycfg_to_local_var '
    CTD=readyCtd
    DELAY_KEYS=cooldownAfterKeys
    DELAY_TEXT=cooldownAfterText
    ')"

  UNUSED_SETTINGS="${UNUSED_SETTINGS# }"
  UNUSED_SETTINGS="${UNUSED_SETTINGS% }"
  if [ -n "$UNUSED_SETTINGS" ]; then
    echo "Unsupported settings in config: $UNUSED_SETTINGS"
    echo
  fi

  local N_TODO="${#TODO[@]}"
  if [ "${REMAINING_AUTO_CONFIRMS:0:1}" == '!' ]; then
    echo "!! Precautionary Forced Confirmation Mode was triggered. !!" \
      "Reason: ${REMAINING_AUTO_CONFIRMS:1}"
    echo
    REMAINING_AUTO_CONFIRMS=0
  fi
  [ "${REMAINING_AUTO_CONFIRMS:-0}" -ge 1 ] || REMAINING_AUTO_CONFIRMS=0
  if [ "$N_TODO" -gt "$REMAINING_AUTO_CONFIRMS" ]; then
    echo "The number of interaction steps ($N_TODO)" \
      "exceeds the limit for pre-confirmed interactions" \
      "(autoConfirmInteractions=$REMAINING_AUTO_CONFIRMS)." \
      "When asked, press any text-producing single key (e.g. space bar)" \
      "to confirm, or press Ctrl+c to abort."
    echo "You will be asked confirmation for $((
      N_TODO - REMAINING_AUTO_CONFIRMS )) interactions."
    echo
  fi

  wcc_countdown || return $?

  local TASK= DESCR= BUF=
  local INSTRUCTION_COUNTER=0
  for TASK in "${TODO[@]}"; do
    DESCR="${TASK%% >> *}"
    TASK="${TASK#* >> }"
    (( INSTRUCTION_COUNTER += 1 ))
    [ "$REMAINING_AUTO_CONFIRMS" != 1 ] \
      || echo $'\n--- Entering confirmation mode! ---\n'

    echo "#$INSTRUCTION_COUNTER"$'\t'"$DESCR"
    if [ "$REMAINING_AUTO_CONFIRMS" -ge 1 ]; then
      (( REMAINING_AUTO_CONFIRMS -= 1 ))
    else
      echo -n $'\t'"interaction: $TASK     <- confirm? "
      read -rs -n 1 BUF || return $?
      echo
    fi
    wcc_do_chain "$TASK" || return $?
  done
}
















return 0
