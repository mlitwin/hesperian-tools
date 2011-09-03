#!/bin/sh

convert_image () {
  SOURCEFILE=$1
  DESTFILE=$2
  DESTDIR=$( dirname "$DESTFILE")

  # Make sure our destination directory exists
  mkdir -p "$DESTDIR"

  convert "$SOURCEFILE" -matte \
  -channel Alpha -fx "a*(1-(r+b+g)/3.0)" \
  -channel red -fx "0" -channel green -fx "0" -channel blue -fx "0" \
  "$DESTFILE"

}

SOURCEDIR=${1:-images}
DESTDIR=${2:-newimages}

for file in ${SOURCEDIR}/*.png; do
  fname=`basename "$file"`
  destname=${DESTDIR}/${fname}
  printf "Converting ${file}..."
  convert_image "${file}" "${destname}"
  printf "done\n"
done
