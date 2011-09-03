#!/bin/sh
COMMAND=$1
I=${2:-/var/www/devwikis/pool.dev.hesperian.org/www/w/images}

IMAGEDIRS="$I/0 $I/1 $I/2 $I/3 $I/4 $I/5 $I/6 $I/7 $I/8 $I/9 $I/a $I/b $I/c $I/d $I/e $I/f"

find $IMAGEDIRS -name \*.png -print0 | xargs -0 -n1 ./image_convert.sh ${COMMAND} newimages

echo DONE
