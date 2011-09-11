#!/usr/bin/perl -w
use strict;
use Getopt::Long;

use File::Basename;
use File::Path qw(make_path);
use File::Find;


my $convert = "convert";

my ($resizeSize, $degrayAlpha, $wikidir);

GetOptions("resizeSize:s", \$resizeSize,
  "degrayAlpha:s", \$degrayAlpha,
  "wikidir", \$wikidir);

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
my @cmd_base = ($convert, @{$Converts{$Command}});


sub do_command {
  my ($i, $o) = @_;
  my @cmd = (@cmd_base, $i, $o);
  print join(' ',@cmd), "\n";

  my $basedir = dirname($o);
  make_path($basedir);

  my $rc = system(@cmd);
  if ($rc & 127) { die "convert terminated" }
  return $rc;
}

sub do_one_image {
  return unless -f $_;
  my $bn = basename($_);
  return if $bn =~ /^\./;

  my $destpath = $Dest . substr $_, length($Source);
  do_command($_, $destpath);
};

if (-d $Source) {  
  my @ImageDirs = $wikidir ?  map { "$Source/$_"} qw(0 1 2 3 4 5 6 7 8 9 a b c d e f): ($Source);

  find({ wanted => \&do_one_image, no_chdir => 1 }, @ImageDirs);
} else {
  do_command($Source,$Dest);
}
