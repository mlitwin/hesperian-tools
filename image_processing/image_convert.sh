#!/bin/sh

convert_image () {
  COMMAND=$1
  SOURCEFILE=$2
  DESTFILE=$3
  DESTDIR=$( dirname "$DESTFILE")

  case $COMMAND in
  	transparent )
        	CONVERT_ARGS="-matte -channel Alpha -fx \"a*(1-(r+b+g)/3.0)\" \
  -channel red -fx 0 -channel green -fx 0 -channel blue -fx 0" 
                    ;;
  	resize )
        	CONVERT_ARGS="-resize 20x20>"
                    ;;
  esac 

  # Make sure our destination directory exists
  mkdir -p "$DESTDIR"

  convert "$SOURCEFILE" $CONVERT_ARGS "$DESTFILE"
}

COMMAND=${1}
DESTDIR=${2}
FILE=${3}

FNAME=$( basename "$FILE" )

# We'll mirror the hierarchy starting after ../images/
RELATIVEPATH=$( echo $FILE | sed "s/^\/.*\/images\///" )
OUTDIR=$DESTDIR/$( dirname "$RELATIVEPATH")
OUTFILE=$OUTDIR/$FNAME

printf "${COMMAND}: ${FILE} into ${OUTFILE}..."
convert_image "${COMMAND}" "${FILE}" "${OUTFILE}"
printf "done\n"
