#!/usr/bin/perl -w
# Simple file renaming - mostly intended for images.
# Script is intended to be hacked for specific purposes -
# modify the make_newname() function below.

use strict;

use File::Basename;
use File::Spec;
use File::Path qw(make_path);
use File::Find;

# Calculate new name of file.
sub make_newname {
  my $oldname = shift;
  my $newname = $oldname;
  
  # Regular expression to mutate the name - here is where you'll hack.
  # Slashes separate the parts of the regex s/Part #1/Part #1/;
  # Part #1 determines the names you match - the ones you want to change
  # Part #2 determines how the name will in fact change
  # In Part #1, put parentheses around the parts you want to remember
  # In Part #2, refer to the "captured" parts in parenthesis by $1 for the first
  #   parenthesis group, $2 for the second.

  $newname =~ s/(wdp)(.*\.png)$/xxx$2/;
  
  return $newname;
}

my ($sourcedir, $destdir) = @ARGV;

$destdir = File::Spec->rel2abs($destdir);

make_path($destdir);

sub rename_file {
  return if -d $_;
  
  my $newname = make_newname($_);
  my $newpath = File::Spec->catfile($destdir, $newname);
  
  print "$_ -> $newpath\n";
}

find({ wanted => \&rename_file}, $sourcedir);

0;

