#!/bin/bash

git init
git add -A
read -r -p " Why are you updating this " comment
git commit -m " $comment "
git push origin dev 
