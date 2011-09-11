#!/usr/bin/perl -w
use strict;
use Getopt::Long;

use File::Basename;
use File::Path qw(make_path);

my $convert = "convert";

my ($resizeSize, $degrayAlpha);

GetOptions("resizeSize:s", \$resizeSize,
  "degrayAlpha:s", \$degrayAlpha);

$resizeSize = $resizeSize || '800x800>';
$degrayAlpha = $degrayAlpha || '.09';

my ($Command, $Source, $Dest) = @ARGV;

my @transparent = split(/ /, '-matte -channel Alpha -fx a*(1-(r+b+g)/3.0) -channel red -fx 0 -channel green -fx 0 -channel blue -fx 0');

my @resize =  (split(/ /, '-density 72 -resize'), $resizeSize);

my @degray = split(/ /, "-matte -channel alpha -fx (a-1)/(1-$degrayAlpha)+1 -channel red -fx 0 -channel green -fx 0 -channel blue -fx 0");

my %Converts = (
  'transparent' => \@transparent,
  'resize' => \@resize,
  'degray' => \@degray,
);

die "Unknown command $Command" unless exists($Converts{$Command});

my @cmd = ($convert, @{$Converts{$Command}}, $Source, $Dest);

print join(' ',@cmd), "\n";

my $basedir = dirname($Dest);
make_path($basedir);

my $rc = system(@cmd);
if ($rc & 127) { die "convert terminated" }
return $rc;
