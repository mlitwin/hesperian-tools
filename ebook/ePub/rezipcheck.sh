#!/bin/sh

java -Djava.awt.headless=true -jar ../tools/epubcheck-4.0.0/epubcheck.jar ${1} -mode exp -save
