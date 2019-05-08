#!/bin/bash

STANZANAME=$1

function check_stanza {
  STANZA=$(pgbackrest --stanza="$1" info)

  if [[ $STANZA == 'No stanzas exist in the repository.' ]]; then
    result=$(pgbackrest --stanza="$1" stanza-create)
    if [ $? -ne 0 ]; then
      echo $result
      exit 1;
    fi
  fi
}

STATUS=$(curl -s -o /dev/null -w '%{http_code}' localhost:8008)

if [ $STATUS -eq 200 ]; then
  check_stanza $STANZANAME
  exit 0;
fi
echo "This node is not a postgres master. Cant backup"
exit 1;

