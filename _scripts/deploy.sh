#!/usr/bin/env bash

# build jekyll site
cd /Users/Zach/Documents/Developer/personal_site/jekyll_site
JEKYLL_ENV=production bundle exec jekyll build

# copy comp 150 react project as well
cd /Users/Zach/Documents/Developer/personal_site/comp-150-alg-project
yarn build
cp -r build /Users/Zach/Documents/Developer/personal_site/jekyll_site/_site/compression

cd /Users/Zach/Documents/Developer/personal_site/jekyll_site/_site
git add .
git commit -m "publishing site"
git push
