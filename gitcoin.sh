#!/bin/bash

DIFFICULTY=3
LEADING="f"

PREFIX=$(head -c $DIFFICULTY < /dev/zero | tr '\0' $LEADING)

CURRENT=$(git rev-parse --verify HEAD)
if [[ $CURRENT == $PREFIX* ]]; then
  echo 'Please add a new commit to mine'
  exit 1
fi

START=$(date +%s)
while [[ $CURRENT != $PREFIX* ]];do
  END=$(date +%s)
  echo "$CURRENT     $START     $END     $(($END - $START))" | tee .gitcoin-nonce
  git add .gitcoin-nonce

  git commit --amend -C HEAD --no-edit > /dev/null
  CURRENT=$(git rev-parse --verify HEAD)
done

echo "SUCCESS: $CURRENT"
git count-objects
git gc --prune
