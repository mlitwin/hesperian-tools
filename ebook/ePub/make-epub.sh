#!/bin/sh
# Create an ePub from a directory - basically zipping it up.
SRC=`cd "${1}";pwd`
DEST=${SRC%/}.epub
rm -f "${DEST}"
cd ${SRC}
zip -x \*.DS_Store  -Xr "${DEST}" mimetype META-INF OEBPS