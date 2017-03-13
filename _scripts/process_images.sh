#!/usr/bin/env bash
#
# process original (high res) images into thumbnails and "full size", which are
# still good quality but manageably sized.
#
# TODO: this converts every picture in the background simultaneously, so while
# it's running it hogs CPU like crazy.
#
# Zach Kirsch | March 2017

process_image() {
    img="$1"
    date=$(exiftool -s -s -s -d '%Y-%m-%d-%H-%M-%S' -DateTimeOriginal "$img")
    if [[ ! -z "${date}" ]]; then
        filename="${date}.jpg"
        convert "$img" -auto-orient -thumbnail 400x400 "${thumbs}/${filename}"
        convert "$img" -auto-orient -resize 2000x2000 "${fulls}/${filename}"
        echo "resized: $filename"
    else
        echo "Error: could not determine date of image: $img"
    fi
}

set -e # Exit on error
set -m # Enable Job Control

site_root="/Users/Zach/Documents/Developer/personal_site_2"
portfolio_root="${site_root}/assets/portfolio"
img_root="${portfolio_root}/img"

origs="${img_root}/origs"
thumbs="${img_root}/thumbs"
fulls="${img_root}/fulls"

rm -rf "$fulls" "$thumbs" "$origs"
mkdir "$fulls" "$thumbs" "$origs"

echo "Export images to: $origs"
printf "Then press any key to continue...\n"
read -n 1 reply </dev/tty

for img in "${origs}"/*
do
    process_image "$img" &
done

wait

cd "$img_root"
mv "$fulls" portfolio/
zip -r portfolio.zip portfolio
mv portfolio/ "$fulls"
