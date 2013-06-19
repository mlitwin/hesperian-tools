#!/usr/bin/perl
use strict;

my $playorder = 0;

while(<>) {

s/id="[^"]+" *playOrder="[^"]+"/$playorder++, "id=\"navPoint-$playorder\" playOrder=\"$playorder\""/e;
print;

}
