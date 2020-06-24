#!/bin/bash

set -euo pipefail

if [ "$EUID" == "0" ]; then
  echo "Please do not run this script as root"
  exit 2
fi

ALL_ARGS=$@
SHOW_HELP=false
VERBOSE=false
NAME=''
EMAIL=''
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --help|-h)
    SHOW_HELP=true
    break
    ;;
    --verbose)
    VERBOSE=true
    shift
    ;;
    -n|--name)
    NAME="$2"
    shift
    shift
    ;;
    -e|--email)
    EMAIL="$2"
    shift
    shift
    ;;
    *)
    shift
    ;;
  esac
done

if $SHOW_HELP; then
  cat <<EOF
Configures user environment.

Usage:
  `readlink -f $0` [flags]

Flags:
  -n, --name               Name to use when configuring Git.
  -e, --email              Email to use when configuring Git.
      --verbose            Show verbose output
  -h, --help               help
EOF
  exit 0
fi

if $VERBOSE; then
  echo Running `basename "$0"` $ALL_ARGS
  echo Name is $NAME
  echo Email is $EMAIL
fi

if [ "$NAME" != "" ]; then
  git config --global user.name $NAME
elif [[ `git config --global user.name` == "" ]] || [[ `git config --global user.name` == "placeholder" ]]; then
  >&2 echo Name is required.
  exit 2
else
  if $VERBOSE; then
    echo Git name already configured as `git config --global user.name`
  fi
fi
if [ "$EMAIL" != "" ]; then
  git config --global user.email $EMAIL
elif [[ `git config --global user.email` == "" ]] || [[ `git config --global user.email` == "placeholder@lambda3.com.br" ]]; then
  >&2 echo Email is required.
  exit 2
else
  if $VERBOSE; then
    echo Git email already configured as `git config --global user.email`
  fi
fi
