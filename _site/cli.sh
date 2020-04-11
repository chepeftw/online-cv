#!/bin/bash

set -e

SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"
cd $SCRIPT_HOME

case "$1" in
  up)
      docker-compose up -d
    ;;
  down)
      docker-compose down
    ;;
  *)
    echo $"Usage: $0 {up}"
    RETVAL=1
esac

cd - > /dev/null
