#!/usr/bin/env bash

set -e

# directories
site_root=/Users/Zach/Documents/Developer/personal_site
jekyll_source=$site_root/jekyll_site
jekyll_static_site=$jekyll_source/_site
comp_150_source=$site_root/comp-150-alg-project
comp_150_dest=$jekyll_static_site/compression

# build jekyll site
cd $site_root/jekyll_site
JEKYLL_ENV=production bundle exec jekyll build

# copy comp 150 react project as well
cd $comp_150_source
yarn build
cp -r build $comp_150_dest

# push static site to Github
cd $jekyll_static_site
git add .
git commit -m "publishing site"
git push
