use v6.c;
use Test;
use Time::Spec::at;
use Time::Spec::at::Grammar;
use Time::Spec::at::Actions;

my $now = DateTime.now;
diag $now;
my sub tp ($str, :$now) {
  Time::Spec::at::Grammar::At.parse( $str, actions => Time::Spec::at::Actions.new ).made
}

my $match = Time::Spec::at::Grammar::At.parse( "now", actions => Time::Spec::at::Actions::AtActions.new ).made;
dd $match;

pass "fix me";

done-testing;
