#!/bin/sh

source ~/.zshrc

git clone git@github.com:oleander/logger-swift.git
cd logger-swift
git stash

rm -r .build
rm -f Package.resolved

git pull origin master
swift build
