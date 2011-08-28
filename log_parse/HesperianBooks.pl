#!/usr/bin/perl -w
#
# Recast the download report at www.hesperian.info into a more usable form.
#
# Basically, this means classifying .pdf downloads according to book and chapter.
#

use HTML::TableParser;
use LWP;
use CGI qw/:standard *table/;

use strict;

# Gloabl info we will parse out
my %BookStats = ( ); 
my $grandTotalDownloads = 0;

# Set up a UserAgent that can get the source html report to process.
{
    package RequestAgent;
    our @ISA = qw(LWP::UserAgent);

    sub new
    {
        my $self = LWP::UserAgent::new(@_);
        $self->agent("hesperian-request/$main::VERSION");
        $self;
    }

    sub get_basic_credentials
    {
      return('username', 'password');
    }
}

my $ua =  RequestAgent->new;
my $url = "http://hesperian.info/stats/REQUEST.html";

my $r = $ua->get($url);


# TableParser will read our html table
my @reqs = (
{
  id => 1,
  row => \&row,                 # function callback
} );


# create parser object
my $p = HTML::TableParser->new( \@reqs, 
                 { Decode => 1, Trim => 1, Chomp => 1 } );
my $report = $r->content;
$p->parse($report);
$p->eof;

my $timeframe = "";

if( $report =~ m/Report time frame ([^.]*)\./)
{
  $timeframe = $1;
}


# Convert a fraction to a percentage
sub MakePercent {
  my ($num, $denom) = @_;
  my $frac = 1;
  if($denom > 0) {
    $frac  = $num / $denom;
  }
  
  return int(100*$frac);
}


# Main row parser. Extract the row, and gather statistics
sub row  {
  my ( $id, $line, $cols, $udata ) = @_;

  my ($num,$path,$n,$percent,$date) = @{$cols};

  # books are under assest/
  if ( $path =~ m|hesperian\.info/assets/(.*)$| ) {
    $path = $1;
    $path =~ s| HTTP/\d\.\d$||;
  } else {
    return;
  }

  return unless $path =~ /\.pdf$/;

  # The book name is the directory. Chapter name is the filename.
  # If there is no subdirecty, we take bookname = chaptername = filename;
  my ($book,$chapter);

  if($path =~ m|(.*)/(.*)$|) {
    $book = $1;
    $chapter = $2;
  } else {
    $book = $path;
    $chapter = $path;
  }

 $n =~ s/,//g; # Get rid of commas for number
 
  # Accumulate stats for the chapter
  #my $chapterStat = {'title' => $chapter, 'downloads' => $n , 'updated' => $date};
  #$BookStats{$book}->{'Chapters'}->{$chapter} = $chapterStat;
  $BookStats{$book}->{'Chapters'}->{$chapter}->{'title'} = $chapter;

  $grandTotalDownloads += $n;

  $BookStats{$book}->{'Chapters'}->{$chapter}->{'updated'} = $date;

  # Stats for the book, and global statistics.
  $BookStats{$book}->{'TotalDownloads'} += $n;
  $n += $BookStats{$book}->{'Chapters'}->{$chapter}->{'downloads'};
  if( !exists($BookStats{$book}->{'MaxDownloads'}) or $BookStats{$book}->{'MaxDownloads'} < $n) {
    $BookStats{$book}->{'MaxDownloads'} = $n;
  }
  $BookStats{$book}->{'Chapters'}->{$chapter}->{'downloads'} = $n;
}

# Now we have parsed the input, start working on the output.

# Sort the books by MaxDownloads
my @Books = keys(%BookStats);
@Books = sort { $BookStats{$b}->{'MaxDownloads'} <=> $BookStats{$a}->{'MaxDownloads'} } @Books;

# Begin the html output

print header;
print start_html("Hesperian PDF Download Report");

print h3("Report of Book Downloads: $timeframe");

print p("This is a report of the pdf downloads, based on the raw data available from hesperian.info GoDaddy website: ". a({href => "$url"}, $url));

print p("Note: single book downloads are taken to be one large chapter.");
# Summary table
print start_table({-border => 1});
print caption('Summary of Downloads');
print Tr([th(['Book', 'Largest Chapter', 'All Chapters', escapeHTML('%')])]);
foreach my $book (@Books) {
  my $bs = $BookStats{$book};
  my $p = MakePercent($bs->{'TotalDownloads'}, $grandTotalDownloads);
  print Tr(
      td( a({-href => "#$book"}, $book)) .
      td( {-align => 'right' }, $bs->{'MaxDownloads'}) .
      td( {-align => 'right' }, $bs->{'TotalDownloads'}) .
      td( $p)
    );
}
print end_table;

# A table for each book
foreach my $book (@Books) {
  my $bs = $BookStats{$book};
  my @Chapters = sort { $b->{'downloads'} <=> $a->{'downloads'} } values %{$bs->{'Chapters'}};
  my $numChapters = scalar(@Chapters);

  print "<p>\n";
  print a( {-name=>$book});
  print start_table({-border => 1});
  print caption($book);
  print Tr([th(['Chapter', 'Downloads', escapeHTML('%')])]);

  foreach my $cs (@Chapters) {
    my $p = MakePercent($cs->{'downloads'}, $bs->{'TotalDownloads'});
    print Tr(
      td( $cs->{'title'}) .
      td( {-align => 'right' }, $cs->{'downloads'}) .
      td( $p)
    );
  }
  print end_table;
  print "</p>\n";
}

print end_html;
