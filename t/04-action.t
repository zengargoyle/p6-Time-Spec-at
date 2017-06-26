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

my DateTime $match;
$match = Time::Spec::at::Grammar::At.parse( "now", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
ok $match eqv $now, "now is now";

$match = Time::Spec::at::Grammar::At.parse( "now + 1 day", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
ok $match eqv $now.later(days=>1), "now + 1 day";
$match = Time::Spec::at::Grammar::At.parse( "now + 1 year", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
ok $match eqv $now.later(years=>1), "now + 1 year";

$match = Time::Spec::at::Grammar::At.parse( "now - 1 day", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
ok $match eqv $now.earlier(days=>1), "now - 1 day";
$match = Time::Spec::at::Grammar::At.parse( "now - 1 year", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
ok $match eqv $now.earlier(years=>1), "now - 1 year";

$match = Time::Spec::at::Grammar::At.parse( "12:01", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
ok $match eqv DateTime.new(:12hour,:1minute), "12:01";

done-testing;
