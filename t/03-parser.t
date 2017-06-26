use v6.c;
use Test;
use Time::Spec::at;
use Time::Spec::at::Grammar;

my sub tp ($rule,$str) { Time::Spec::at::Grammar::At.parse($str,:$rule) }

pass "fix me";
my @tests = 

  "now",
  "now + 1 min",
  "now + 23 min",
  "now + 1 hour",
  "now + 23 hours",
  "now + 1 day",
  "now + 1 week",
  "now + 1 month",
  "now + 1 year",

  "23:55",
  "23:55 + 7 min",
  "12:00",
  "12:00 + 5 min",
  "12:00 + 2 hours",

  "12:00 dec 17",
  "12:00 oct 17",
  "12:00 oct 17 + 7 days",
  "12:00 oct 17 + 35 days",

  "00:00 Dec 24",
  "00:00 dec 24 + 31 days",
  "00:00 dec 24 + 358 days",

  "23:55 dec 31",
  "23:55 dec 31 + 7 minutes",
  ;

for @tests -> $test {
  ok tp(<TOP>, $test), $test;
}

done-testing;
