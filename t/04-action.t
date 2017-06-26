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
my DateTime $try;
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
$try = $now.clone(:12hour,:1minute);
ok $match eqv $try, "12:01";

$match = Time::Spec::at::Grammar::At.parse( "12:01 + 1 year", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
$try = $now.clone(:12hour,:1minute).later(:1year);
ok $match eqv $try, "12:01 + 1 year";

$match = Time::Spec::at::Grammar::At.parse( "noon", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
$try = $now.clone(:12hour,:0minute, :0second);
ok $match eqv $try, "noon";

$match = Time::Spec::at::Grammar::At.parse( "midnight", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
$try = $now.clone(:0hour,:0minute, :0second);
ok $match eqv $try, "midnight";

$match = Time::Spec::at::Grammar::At.parse( "teatime", actions => Time::Spec::at::Actions::AtActions.new(:$now) ).made;
$try = $now.clone(:16hour,:0minute,:0second);
ok $match eqv $try, "teatime";

done-testing;
