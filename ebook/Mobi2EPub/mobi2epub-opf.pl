#!/usr/bin/perl
use strict;

while(<>) {
  s|href="html/|href="|g;
  s|href="css/|href="|g;
  s|href="xml/|href="|g;
  s|href="misc/|href="|g;
  s|href="image/|href="images/|g;
  s|media-type="image/jpg"/|media-type="image/jpeg"/|g;  
  s|<dc:identifier id="bookid">\d*</dc:identifier>|<dc:identifier id="bookid">9780942364842</dc:identifier>|;

  print;
}
