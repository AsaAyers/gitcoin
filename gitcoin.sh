#!/bin/bash

DIFFICULTY=3
LEADING="0"
if [ -e .gitcoin ]; then
  IFS=: read DIFFICULTY LEADING < .gitcoin
fi

if [ ${#DIFFICULTY} -lt 3 ]; then
  DIFFICULTY=3
fi
if [ ${#LEADING} -gt 1 ]; then
  echo "LEADING must be a single character. Found: '${LEADING}'"
  exit 1
elif [ ${#LEADING} -eq 0 ]; then
  LEADING="0"
fi
echo "Current configuration:"
echo "$DIFFICULTY:$LEADING" | tee .gitcoin
git add .gitcoin

PREFIX=$(head -c $DIFFICULTY < /dev/zero | tr '\0' $LEADING)

CURRENT=$(git rev-parse --verify HEAD)
if [[ $CURRENT == $PREFIX* ]]; then
  echo 'Please add a new commit to mine'
  exit 1
fi

START=$(date +%s)
while [[ $CURRENT != $PREFIX* ]];do
  END=$(date +%s)
  echo "$CURRENT:$START:$END:$(($END - $START))" | tee .gitcoin-nonce
  git add .gitcoin-nonce

  git commit --amend -C HEAD --no-edit > /dev/null
  CURRENT=$(git rev-parse --verify HEAD)
done

echo "SUCCESS: $CURRENT"
git count-objects
git gc --prune
