#!/usr/bin/perl -w

#
# This script translateds email recepts from MIVA
# store orders, and turns them into a tab-delimited
# text file, one line per order.
#

use strict;
use CGI;

my $q  = new CGI;

# If there is a file upload, then we spit out the tab-delimited output.
if( $q->param('uploaded_file'))
{
  my $fh = $q->upload('uploaded_file');

  if (!$fh && $q->cgi_error) {
     print $q->header(-status=>$q->cgi_error);
     exit 0;
   }


# We will map CA -> Canada, etc. in the country field.
my %CountryCodes = ();

open(CC, "<country-codes.txt");
while(<CC>)
{
  chomp;
  /(..)\s*(.*)/;
  $CountryCodes{$1}=$2;
}
close(CC);

my %ShippingAbbrv = (
'Free Shipping' => 'FS',
#'U.S.P.S. Priority Mail® International' =>'PMI',
#'U.S.P.S. Priority Mail®' => 'PI',
);

print $q->header(-type=>'text/plain');

sub GetLine {
 return scalar(<$fh>);
}

my %Order = ();

my $state = "seekingStart";

sub PassesFilter {
  my $filter = $q->param('code_filter');
  return 1 unless $filter;
  foreach my $c (keys %{$Order{codes}}) {
    return 1 if $c eq $filter;
  }
  return 0;
}

sub PrintOrder
{
 my $cc = $Order{country};
 if (exists( $CountryCodes{uc($cc)})) {
   $cc = $CountryCodes{uc($cc)};
 }

 my $ship = $Order{shipping};
 if (exists( $ShippingAbbrv{$ship})) {
   $ship = $ShippingAbbrv{$ship};
 }
  my $codes = join(',',  map { "$_($Order{codes}{$_})"} keys %{$Order{codes}});
  if( PassesFilter()) {
    my $filter_total = "";
    $filter_total = $Order{codes}{'EXTERNAL'} if exists($Order{codes}{'EXTERNAL'});
    print "Order #:$Order{number}\t$Order{placed}\t$Order{name}\t$Order{company}\t$Order{addr2}\t$Order{addr3}\t$cc\t$codes\t$ship\t$Order{email}\t$Order{phone1}\t$filter_total\n";
  }
  %Order = ();
  $state = "seekingStart";
}


sub GetShipTo
{
  my $st = shift;
  my @Words = split(/( +)/, $st);
  my $left = "";
  my $possible = "";
  my $mostSpace = 0;
  foreach my $w (@Words)
  {
    if( $w =~ / /) {
      if( length($w) >= $mostSpace) {
        $left .= $possible;
        $possible = "";
        $mostSpace = length($w);
      }
    }
    $possible .= $w;
  }


 $st = $left;
 $st =~ s/^\s*//;
 $st =~ s/\s*$//;
 return $st;
}

sub GrabAddress {
  $Order{name} = GetShipTo(GetLine());
  $Order{email} = GetShipTo(GetLine());
  $Order{phone1} = GetShipTo(GetLine());
  $Order{phone2} = GetShipTo(GetLine());
  $Order{company} = GetShipTo(GetLine());
  $Order{addr2} = GetShipTo(GetLine());
  $Order{addr3} = GetShipTo(GetLine());
  $Order{country} = GetShipTo(GetLine());
}


while($_ = GetLine())
{
  if ($state eq "seekingStart") {
    if( /Order Number\s*:\s*(\d+)/)
    {
     $Order{number} = $1;
     $state = "seekingPlaced";
    }
  }
  if ($state eq "seekingPlaced") {
    if( /Placed\s*:\s*(.*)$/)
    {
     $Order{placed} = $1;
     $Order{placed} =~ s/\s*$//;
     $state = "seekingShipTo";
    }
  }
  elsif($state eq "seekingShipTo")
  {
    if( /Ship To:/) {
      GrabAddress();
      $state = "seekingOrder";
    }
  }
  elsif($state eq "seekingOrder") {
    if( /-----------------------------------------------/) {
      $state = "seekingOrderEnd";
    }
  }
  elsif($state eq "seekingOrderEnd") {
    if( /-----------------------------------------------/) {
      PrintOrder();
    } else {
      if(/^(\w+)(.+?)(\d+)\s+\$([\d\.]*)\s*\$([\d\.]*)\s*$/) {
        $Order{codes}{$1} = $3;
      }
      if(/Shipping: ([^:]*):/) {
        $Order{shipping} = $1;
      }
    }
  }
}


} else {
  print $q->header;
  print $q->start_html('MIVA Order Extractor');
  print $q->p('Upload a file containing MIVA store orders, and turn them into tab-delimited output, one line per order.');
  print $q->start_multipart_form(-target => '_blank');
  print "File Containing MIVA Order Emails: ";
  print $q->filefield('uploaded_file');
  print $q->br;
  print "Limit Orders by Code: ";
  print $q->textfield(-name =>'code_filter', -default => 'V020');
  print $q->p;
  print $q->submit;
  print $q->end_form;
  print $q->end_html;
}
