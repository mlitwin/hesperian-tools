#!/usr/bin/perl
# Look for a directory where there is a matching gif to a jpg
# and get rid of the jpg. This is part of large-scale jpg -> gif
# conversion processes.
use strict;
use File::Copy;

my @Images = <kindlegensrc-Tawnia/image/*>;
my %Imap = map {$_ => 1} @Images;

mkdir "ExtraJPG";

foreach my $image (@Images) {
  if($image =~ /([^\/]*)\.jpg$/) {
    my $fname = $1;
    (my $gif = $image) =~ s/\.jpg$/.gif/;
    if( $Imap{$gif}) {
      my $newpath = "ExtraJPG/$fname.jpg";
    print "$image -> $newpath\n";
      move($image, $newpath);
    }
  }
}
