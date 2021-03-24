#!/usr/bin/env bash

([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] ||
 [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] ||
 [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && SOURCED=1 || SOURCED=0

if [ "$SOURCED" = "0" ]
then
  echo "You cannot run this script directly - instead, you need to 'source' it, like so: 'source $0'"
  exit 1
fi

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
