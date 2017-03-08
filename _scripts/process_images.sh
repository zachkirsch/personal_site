#!/usr/bin/env bash
#
# process original (high res) images into thumbnails and "full size", which are
# still good quality (1200x750) but manageably sized.
#
# Zach Kirsch | March 2017

process_image() {
    img="$1"
    date=$(exiftool -s -s -s -d '%Y-%m-%d-%H-%M-%S' -DateTimeOriginal "$img")
    if [[ ! -z "${date}" ]]; then
        filename="${date}.jpg"
        convert "$img" -auto-orient -thumbnail 360x225 "${thumbs}/${filename}"
        convert "$img" -auto-orient -resize 1200x750 "${fulls}/${filename}"
        # echo "☑️️  $filename"
    else
        echo "Error: could not determine date of image: $img"
    fi
}

set -e # Exit on error
set -m # Enable Job Control

img_root="/Users/Zach/Documents/Developer/personal_site_2/assets/portfolio/img"
origs="${img_root}/origs"
thumbs="${img_root}/thumbs"
fulls="${img_root}/fulls"

rm -rf "${thumbs}"
rm -rf "${fulls}"

mkdir "${thumbs}"
mkdir "${fulls}"

for img in "${origs}"/*
do
    process_image "$img" &
done

wait
