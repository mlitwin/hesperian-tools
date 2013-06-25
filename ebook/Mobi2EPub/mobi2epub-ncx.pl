#!/usr/bin/perl
use strict;

while(<>) {
  s|href="../html/|href="|g;
  s|src="../html/|src="|g;
  s|href="../css/|href="|g;
  s|href="xml/|href="|g;
  s|href="../misc/|href="|g;
  s|href="../image/|href="images/|g;
  s|src="../image/|src="images/|g;
  s|media-type="image/jpg"/|media-type="image/jpeg"/|g;
  
  s|<meta name="dtb:uid" content="\d*"/>|<meta name="dtb:uid" content="9780942364842"/>|;

  print;
}
