#!/usr/bin/env bash

SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] ||
 [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] ||
 [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && SOURCED=1 || SOURCED=0

if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "/help" ] || [ "$1" = "/h" ] || [ "$1" = "/?" ] || [ "$1" = "help" ]
then
  echo ""
  echo "NAME"
  echo "       assume-role.sh"
  echo ""
  echo "DESCRIPTION"
  echo "       Assume the given role within the given account id for the given duration"
  echo "       in seconds."
  echo "       The prerequisite for this to work is that your local aws cli setup has"
  echo "       been configured with a valid set of an AWS Access Key Id and AWS Secret"
  echo "       Access Key, for an IAM user that is allowed to assume the given role."
  echo ""
  echo "SYNOPSIS"
  echo "          source ${SCRIPT_FOLDER} [ACCOUNTID] [ROLE] [DURATION]"
  echo ""
  echo "       Note how this script must be sourced - it cannot be run directly."
  echo ""
  echo "ARGUMENTS"
  echo "       ACCOUNTID"
  echo ""
  echo "       The id of the AWS account to which the role belongs."
  echo "       Default: 230024871185"
  echo ""
  echo "       ROLE"
  echo ""
  echo "       The name of the role to assume. Default: AccountManager"
  echo ""
  echo "       DURATION"
  echo ""
  echo "       The duration (seconds) for how long the assumed role remains valid."
  echo "       Default: 3600"
  echo ""
else
  if [ "$SOURCED" = "0" ]
  then
    echo "You cannot run this script directly - instead, you need to 'source' it, like so: 'source $0'"
    exit 1
  fi

  if [ "$1" = "" ]
  then
    ACCOUNTID="230024871185"
  else
    ACCOUNTID="$1"
  fi

  if [ "$2" = "" ]
  then
    ROLE="AccountManager"
  else
    ROLE="$2"
  fi

  if [ "$3" = "" ]
  then
    DURATION="3600"
  else
    DURATION="$3"
  fi

  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN

  CREDENTIALS=$(aws sts assume-role --role-arn "arn:aws:iam::${ACCOUNTID}:role/${ROLE}" --role-session-name "${ROLE}@${ACCOUNTID}" --duration-seconds "${DURATION}" --output text --color off | grep CREDENTIALS)

  if [ "$?" != "0" ]
  then
    echo "Could not assume role, exiting."
  else
    AWS_ACCESS_KEY_ID=$(echo "$CREDENTIALS" | cut -f 2)
    AWS_SECRET_ACCESS_KEY=$(echo "$CREDENTIALS" | cut -f 4)
    AWS_SESSION_TOKEN=$(echo "$CREDENTIALS" | cut -f 5)

    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN

    echo "You are now acting as role ${ROLE} in account ${ACCOUNTID} for the next ${DURATION} seconds (i.e. $(echo "scale=2; $DURATION/60.0" | bc) minutes or $(echo "scale=2; $DURATION/60.0/60.0" | bc) hour(s))."
  fi
fi
