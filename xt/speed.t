#!perl
use strict;
use warnings;
use Test::More;
use Time::HiRes qw/time/;
use Search::Tokenizer;

my $tokenizer = Search::Tokenizer->new(
  regex           => qr/\w+(?:'\w+)?/,
  filter_in_place => sub {$_[0] =~ s/'.*//}, # remove quotes
  lower           => 0,
 );

open my $fh, "<", $INC{'Search/Tokenizer.pm'} or die $!;
my $source_code = do {local $/; <$fh>};
close $fh;
my $large_string = $source_code x 10;


my $time_for_native_string = time_for(sub {count_words($large_string)});
utf8::upgrade($large_string);
my $time_for_utf8_string   = time_for(sub {count_words($large_string)});
note sprintf "large_string(%d chars) : %.4f native, %.4f utf8",
  length($large_string),
  $time_for_native_string,
  $time_for_utf8_string;
ok ($time_for_utf8_string <= 3*$time_for_native_string, "utf8 string not too much slower than native");

done_testing();


sub count_words {
  my $string   = shift;
  my $iterator = $tokenizer->($string);
  my @words    = Search::Tokenizer::unroll($iterator, 1);
  return scalar @words;
}


sub time_for {
  my $sub = shift;
  my $t0 = time;
  $sub->();
  my $t1 = time;
  return $t1 - $t0;
}
