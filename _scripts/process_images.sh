#!/usr/bin/env bash
#
# process original (high res) images into thumbnails and "full size", which are
# still good quality but manageably sized. Uses GNU Parallel to process 5 at a
# time.
#
# To use: run the script, and the export the high-res photos into the "origs"
# folder
#
# To erase existing images and start from scratch, run:
#   sh process_images scratch
#
#
# Zach Kirsch | March 2017

site_root="/Users/Zach/Documents/Developer/personal_site_3"
portfolio_root="${site_root}/assets/portfolio"
img_root="${portfolio_root}/img"

origs="${img_root}/origs"
thumbs="${img_root}/thumbs"
fulls="${img_root}/fulls"

process_image() {
    img="$1"
    thumbs="$2"
    fulls="$3"
    date=$(exiftool -s -s -s -d '%Y-%m-%d-%H-%M-%S' -DateTimeOriginal "$img")
    if [[ ! -z "${date}" ]]; then
        filename="${date}.jpg"
        convert "$img" -strip -auto-orient -quality 10 -thumbnail 2000x2000 -blur 20x20 "${thumbs}/${filename}"
        convert "$img" -auto-orient -resize 2000x2000 "${fulls}/${filename}"
        # echo "resized: $filename"
    else
        echo "Error: could not determine date of image: $img"
    fi
}

set -e # Exit on error

rm -rf  "$origs"
mkdir "$origs"
if [[ "$1" == "scratch" ]];  then
    rm -rf "$fulls" "$thumbs"
    mkdir "$fulls" "$thumbs"
fi

printf "Export images to: $origs. Then press any key to continue...\n"
read -n 1 reply </dev/tty

export -f process_image
parallel --bar -j 5 "process_image {} ${thumbs} ${fulls}" ::: "${origs}"/*

printf "Compressing portfolio...\n"
cd "$img_root"
mv "$fulls" portfolio/
zip -qr portfolio.zip portfolio
mv portfolio/ "$fulls"
