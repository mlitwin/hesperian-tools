#!/usr/bin/perl
use strict;
use File::Path qw(make_path remove_tree);
use File::Copy;

#my $mobidir = "Mobisrc-vendor";
my $mobidir = "Hesperian_MOBI_final2toc-src-testing";
my $epubTemplate = "ePubsrc-vendor-test";
my $outdir = "ePubsrc-converted";
my $epubConverted = "ePub-converted.epub";

my @HTML = glob("$mobidir/html/*.html");
remove_tree($outdir);
`rm $epubConverted`;

# Set up the basic skeleton
make_path("$outdir/META-INF/");
`cp -R $epubTemplate/OEBPS/ $outdir/OEBPS/`; `rm $outdir/OEBPS/*.html`;
`rm -r $outdir/OEBPS/images`;

copy("$epubTemplate/mimetype","$outdir/mimetype") or die "Can't copy mimetype file: $!";
copy("$epubTemplate/META-INF/container.xml","$outdir/META-INF/container.xml") or die "Can't copy container.xml file: $!";


# Process mobi files -> epub ones
# grab images
`cp -R $mobidir/image/ $outdir/OEBPS/images`;


foreach my $h (@HTML) {
  my $f = $h; $f =~ s|.*/|$outdir/OEBPS/|;
  `perl mobi2epub.pl < $h > $f`;
}

my $mobiOPF = glob("$mobidir/*.opf");

`perl mobi2epub-opf.pl < $mobiOPF > $outdir/OEBPS/content.opf`;

my $mobiNXC = "$mobidir/xml/nested-toc.ncx";
`perl mobi2epub-ncx.pl < $mobiNXC > $outdir/OEBPS/toc.ncx`;


chdir($outdir);
`zip -x \\*.DS_Store  -Xr ../$epubConverted  mimetype META-INF OEBPS`;

`java -jar ../../tools/epubcheck-3.0/epubcheck-3.0.jar ../$epubConverted`;

# testing code - diff template vs conversion of mobi
#print "diff -r $epubTemplate $outdir\n"; 
#print `diff -r -wi --strip-trailing-cr $epubTemplate $outdir`;