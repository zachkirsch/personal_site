#!/usr/bin/env bash

img_root="/Users/Zach/Documents/Developer/personal_site_2/assets/portfolio/img"
origs="${img_root}/origs"
thumbs="${img_root}/thumbs"
fulls="${img_root}/fulls"

rm -f "${thumbs}"/*
rm -f "${fulls}"/*

for img in "${origs}"/*
do
    date=$(exiftool -s -s -s -d '%Y-%m-%d-%H-%M-%S' -DateTimeOriginal "$img") \
    && filename="${date}.jpg" \
    && convert "$img" -auto-orient -thumbnail 360x225 "${thumbs}/${filename}" \
    && convert "$img" -auto-orient -resize 1200x750 "${fulls}/${filename}" \
    && echo "☑️️  $filename"
done
