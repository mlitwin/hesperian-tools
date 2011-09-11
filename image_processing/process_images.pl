#!/usr/bin/perl -w
use strict;
use File::Find;
use File::Basename;

my $Command = shift;

my $I = shift || "/var/www/devwikis/pool.dev.hesperian.org/www/w/images";
my $Destdir = shift || "newimages";

my @ImageDirs = ( "$I/0", "$I/1", "$I/2", "$I/3", "$I/4", "$I/5", "$I/6", "$I/7", "$I/8", "$I/9", "$I/a", "$I/b", "$I/c", "$I/d", "$I/e", "$I/f");

sub do_one_image {
  return unless -f $_;
  my $bn = basename($_);
  return if $bn =~ /^\./;

  my $destpath = $Destdir . substr $_, length($I);
  my $rc = system("./image_convert.pl", $Command, $_, $destpath);
  if ($rc & 127) { die "image_convert.pl terminated" }
};

find({ wanted => \&do_one_image, no_chdir => 1 }, @ImageDirs);

print "DONE\n";
