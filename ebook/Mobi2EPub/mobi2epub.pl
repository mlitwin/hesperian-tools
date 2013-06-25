#!/usr/bin/perl
use strict;

while(<>) {
  s|href="\.\./css/|href="|g;
  s|href="\.\./misc/|href="|g;
  s|src="\.\./image/|src="images/|g;
  s|<img height="\d*" width="\d*"|<img|g;
  s|<p class="indent" style="margin-top: 0%;"|<p class="indent"|g;
  s|<p class="hanga">&nbsp;&nbsp;&nbsp;&nbsp;&#x2022;|<p class="hanga">&#x2022;|g;
  
  s|<h3 style="margin-top: 0%;"|<h3|g;
  
  s|<p class="bordera" style="margin-top: 0em;"><hr/>(.*)<hr/></p>|<p class="bordera">$1</p>|g;
  s|<p class="hang">&nbsp;&nbsp;&nbsp;&nbsp;|<p class="hang">|g;


  s|<p class="hang" style="margin-top: 1em;">&nbsp;&nbsp;&nbsp;&nbsp;|<p class="hang" style="margin-top: 1em;">|g;
  s|Where There is No Doctor|Where There Is No Doctor|g;

  s|<p class="indent" style="margin-top: 0em;">|<p class="indent" style="margin-top: 1em;">|g;

  s|^<blockquote><div>|<blockquote>|;
  s|^</div></blockquote>|</blockquote>|;
  s|alt="Image" height="99%"||g;
  
  s|<p class="hangc" style="margin-top: 1.0em;">|<p class="hangc" style="margin-top: 1.5em;">|g;
  s|Where There is No Doctor|Where There Is No Doctor|g;

  s|<h2 style="margin-top: 0%;"( id="[^"]*")>|<h2$1>|g;
  
  #s|<p class="hang">\d+.|<p class="indent">|g;
  
  s|<p class="noindent" style="margin-top: 0em;">|<p class="noindent">|g;
  s|<p class="hangb">&nbsp;&nbsp;&nbsp;&nbsp;|<p class="hangb">|g;
  
  s|<p class="captionl" style="margin-top: 0em;">|<p class="captionl">|g;
  s|<p class="noindent"><b>|<p class="hang0n1"><b>|;
  s|<p class="idx1">&nbsp;&nbsp;&nbsp;&nbsp;|<p class="idx1">|;
  
  s|(&nbsp;)+&#x2022|&#x2022|g;
  
  if(! m|<br/>&nbsp;&nbsp;&nbsp;&nbsp;|) {
    s|&nbsp;&nbsp;&nbsp;&nbsp;||;
  }
  
  s!(&#x005F;|&#x00A0;)&#x005F;!&#x00A0;&#x00A0;!g;
  s!(&#x005F;|&#x00A0;)&#x005F;!&#x00A0;&#x00A0;!g;
  
  
  s|<td valign="top"><p class="hang">(.*)</p></td>|<td valign="top" style="padding-left: 2em; text-indent: -1em;">$1</td>|;
  
  # ch table attempt
  if(m|(.*Name in Your Area: )( +)(</p>)|) {
   my $a = $1;
   my $sp = $2;
   my $b =$3;
   $sp =~ s| |&#x00A0;|g;
   $sp ="&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;";
    $_ = "$a$sp$b\r\n"; 
  }
  if(m|(.*Name in Your Area: <b>)( +)(</b></p>)|) {
   my $a = $1;
   my $sp = $2;
   my $b =$3;
   $sp =~ s| |&#x00A0;|g;
   $sp ="&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;&#x00A0;";
    $_ = "$a$sp$b\r\n"; 
  }
    
  # epubcheck fixes
  s|<br>|<br/>|g;
  s|<hr>|<hr/>|g;
  s|(<p[^>]*>)<hr/>|$1|;
  s|<hr/></p>|</p>|;
    
  print;
}
