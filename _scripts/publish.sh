#!/usr/bin/env bash

cd /Users/Zach/Documents/Developer/personal_site_3/
JEKYLL_ENV=production jekyll build
cd /Users/Zach/Documents/Developer/personal_site_3/_site
git add .
git commit -m "publishing site"
git push
