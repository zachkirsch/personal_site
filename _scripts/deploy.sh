#!/usr/bin/env bash

cd /Users/Zach/Documents/Developer/personal_site/personal_site
JEKYLL_ENV=production bundle exec jekyll build
cd /Users/Zach/Documents/Developer/personal_site/personal_site/_site
git add .
git commit -m "publishing site"
git push
