#!/usr/bin/perl
use Text::CSV;

my $book_order = {
'Where There Is No Doctor' => 1,
'Where Women Have No Doctor' => 2,
'A Community Guide to Environmental Health' => 3,
'A Book for Midwives - New Ed.' => 4,
'A Book for Midwives' => 4.3,
'A Book for Midwives - First Ed.' => 4.7,
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

sub booknameOrder {
  my $name = shift;
  
  if(!exists($book_order->{$name})) {
   # warn "Unknow book '$name'";
    return 0;
  }
  
  return $book_order->{$name};
}

sub webNotesOrder {
  my $note = shift;
  
  return 0 if $note eq '';
  return 1 if $note eq 'In Progress';
  return 2 if $note =~ /Out of Print/;
  
  #print "'$note'\n";
  #warn "Unknown web note $note";
  
  return 0;
}

$csv = Text::CSV->new({binary => 1});              # create a new object

@books = ();

while(<>) {
  $line = $_;
  $line =~ s/\cK/ /g;
  $csv->parse($line);
  my @columns = $csv->fields();
  push @books, \@columns;
}

sub sortbook {
  my $ret;
  
  $ret = $a->[0] cmp $b->[0];
  return $ret if $ret != 0;

  $ret = webNotesOrder($a->[-1]) <=> webNotesOrder($b->[-1]);
  return $ret if $ret != 0;
  
  $ret = booknameOrder($a->[1]) <=> booknameOrder($b->[1]);
  return $ret if $ret != 0;
  
  return 0;
}

foreach my $row (@books) {
  @{$row}[1] =~ s/\s*$//;
  @{$row}[1] =~ s/A Book of Midwives/A Book for Midwives/;
  @{$row}[1] =~ s/A Book for Midwives - New Edition/A Book for Midwives - New Ed./i;
  
  @{$row}[1] =~ s/\sis\s/ Is /g;
 
  @{$row}[1] =~ s/Water for LIfe/Water for Life/;
  

  @{$row}[-1] =~ s/\s*$//;
  @{$row}[-1] =~ s/out of print/Out of Print/i;
  @{$row}[-1] =~ s/in progress/In Progress/i;
  @{$row}[-1] =~ s/inn progress/In Progress/i;
  @{$row}[-1] =~ s/Out of Stock/Out of Print/i;
 
  

 }

@sbooks = sort sortbook @books;

foreach my $row (@sbooks) {
$csv->combine (@{$row});
print $csv->string(), "\n";
#  print join('|', @{$row}), "\n";
}

