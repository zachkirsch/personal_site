#!/usr/bin/env bash
#
# process original (high res) images into thumbnails and "full size", which are
# still good quality but manageably sized. Uses GNU Parallel to process 5 at a
# time.
#
# To use:
#   (1) run the script, sh process_images
#   (2) when prompted, export the high-res photos into the "origs" folder
#
#
# Zach Kirsch | March 2017

help_option="-h"

site_root="/Users/Zach/Documents/Developer/personal_site/jekyll_site"
portfolio_root="${site_root}/assets/portfolio"
img_root="${portfolio_root}/img"

origs="${img_root}/origs"
thumbs="${img_root}/thumbs"
fulls="${img_root}/fulls"

process_image() {
    img="$1"
    thumbs="$2"
    fulls="$3"
    uuid="$4"
    date=$(exiftool -s -s -s -d '%Y-%m-%d-%H-%M-%S' -DateTimeOriginal "$img")
    if [[ ! -z "${date}" ]]; then
        filename="${date}-${4}.jpg"

        # thumbnail
        convert "$img" -strip               \
                       -auto-orient         \
                       -quality 10          \
                       -thumbnail 2000x2000 \
                       -blur 20x20          \
                "${thumbs}/${filename}"

        # full image
        convert "$img" -auto-orient      \
                       -quality 92       \
                       -resize 2000x2000 \
                "${fulls}/${filename}"
    else
        echo "Error: could not determine date of image: $img"
    fi
}

## USAGE

if [[ "$1" == "$help_option" ]]; then
cat << EOF
usage:
    sh $0 | when prompted, export the high-res photos into origs directory
    sh $0 $scratch_option | to erase existing images and start from scratch

    origs directory: $origs
EOF
exit 0
fi

## END USAGE

set -e # Exit on error

rm -rf "$fulls" "$thumbs" "$origs"
mkdir "$fulls" "$thumbs" "$origs"

printf "Export images to: $origs. Then press any key to continue...\n"
read -n 1 reply </dev/tty

export -f process_image
MAX_PROC=5
parallel --bar -j $MAX_PROC \
    "process_image {} ${thumbs} ${fulls} {#}" ::: "${origs}"/*

printf "Compressing portfolio...\n"
cd "$img_root"
mv "$fulls" portfolio/
rm portfolio.zip
zip -qr portfolio.zip portfolio
mv portfolio/ "$fulls"
