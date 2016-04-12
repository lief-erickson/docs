#!/usr/bin/env bash

# CI deployment script

if [ "$TRAVIS_PULL_REQUEST" = "false" -a "$TRAVIS_BRANCH" = "develop" ]; then
  export SSH_DIR=$PWD/.travis
  export SITE_DIR=$PWD/dita-ot.github.io

  # install SSH key
  eval "$(ssh-agent -s)"
  chmod 600 $PWD/.travis/ditaotbot_rsa
  ssh-add $PWD/.travis/ditaotbot_rsa

  cd $SITE_DIR

  # clean
  ruby ../.travis/clean.rb
  # commit site
  git config user.email "ditaotbot@gmail.com"
  git config user.name "DITA-OT Bot"
  git commit -a -m "Deploy dita-ot/docs@${TRAVIS_COMMIT:0:7} to 'dev' docs"
  # push
  git remote set-url origin git@github.com:dita-ot/dita-ot.github.io.git
  git push -v origin master
fi