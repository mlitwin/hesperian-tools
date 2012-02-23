#!/usr/bin/perl
use Text::CSV;

my $book_order = {
'Where There Is No Doctor' => 1,
'Where Women Have No Doctor' => 2,
'A Community Guide to Environmental Health' => 3,
'A Book for Midwives' => 4,
'Where There Is No Dentist' => 5,
'Helping Health Workers Learn' => 6,
'Disabled Village Children' => 7,
'Health Handbook for Women with Disabilities' => 8,
'Helping Children Who Are Deaf' => 9,
'Helping Children Who Are Blind' => 10,
'Pesticides are Poison' => 11,
'Sanitation and Cleanliness' => 2,
'Water for Life' => 13,
};

sub bookname_cmp {
my ($book_a, $book_b) = @_;

return $book_order{$book_a} <=> $book_order{$book_b};
}

$csv = Text::CSV->new({binary => 1});              # create a new object

@books = ();

while(<>) {
  $line = $_;
  $csv->parse($line);
  my @columns = $csv->fields();
  push @books, \@columns;
}

sub sortbook {
  $ret = bookname_cmp($a->[1], $b->[1]);
  return $ret if $ret;
  return 0;
}

@sbooks = sort sortbook @books;

foreach my $row (@sbooks) {
  print join('|', @{$row}), "\n";
}

