#!/usr/bin/env bash

cd /Users/Zach/Documents/Developer/personal_site_2/
jekyll build
cd /Users/Zach/Documents/Developer/personal_site_2/_site
git add .
git commit -m "publishing site"
git push
