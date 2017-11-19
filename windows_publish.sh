#!/bin/sh
git add .
git commit -m "update"
cd /e/source/git/github/algorithm-learn
git checkout master
git pull
git checkout gh-pages
git pull
cd /e/source/git/gitbook/zhangjk/algorithm-learn
gitbook build
yes | cp -rf /e/source/git/gitbook/zhangjk/algorithm-learn/_book/* /e/source/git/github/algorithm-learn/
cd /e/source/git/github/algorithm-learn
git checkout gh-pages
git add -A .
git commit -m "update"
git push
git checkout master
rsync -av --exclude='_book' --exclude='.git' --exclude='node_modules' ../../gitbook/zhangjk/algorithm-learn/ .
cp SUMMARY.md README.md
git add -A .
git commit -m "update"
git push
