#!/bin/bash

DIFFICULTY=2

PREFIX=$(head -c $DIFFICULTY < /dev/zero | tr '\0' '0')

CURRENT=$(git rev-parse --verify HEAD)
if [[ $CURRENT == $PREFIX* ]]; then
  echo 'Please add a new commit to mine'
  exit 1
fi

while [[ $CURRENT != $PREFIX* ]];do
  echo $CURRENT | tee .gitcoin-nonce
  git add .gitcoin-nonce

  git commit --amend -C HEAD --no-edit > /dev/null
  CURRENT=$(git rev-parse --verify HEAD)
done

echo "SUCCESS: $CURRENT"
git count-objects
git gc --prune
