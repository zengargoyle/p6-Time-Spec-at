
use v6.c;
use Test;

use Time::Spec::at;
use Time::Spec::at::Grammar;
use Time::Spec::at::Actions;

# set a consistent $now for testing

my $now = DateTime.now;
diag $now;

# helper functions

my sub tpa ($str, :$now = $UNIT::now) {
  Time::Spec::at::Grammar::At.parse(
    $str,
    actions => Time::Spec::at::Actions::AtActions.new(:$now),
  );
}

my sub tpam (|c) { tpa(|c).made; }

# tests

my DateTime $match;
my DateTime $try;

# spec_base

$match = tpam( "now" );
ok $match eqv $now, "now";


$match = tpam( "today" );
$try = $now.Date.DateTime;
ok $match eqv $try, "today";

$match = tpam( "tomorrow" );
$try = $now.Date.later(:1day).DateTime;
ok $match eqv $try, "tomorrow";

todo "fix next day_name logic", 3;
$match = tpam( "wed" );
$try = Date.new(2017,6,27).later(:1day).DateTime;
ok $match eqv $try, "wed";
# todo "fix next day_name logic";
$match = tpam( "mon" );
$try = Date.new(2017,6,27).earlier(:1day).later(:1week).DateTime;
ok $match eqv $try, "mon";
# todo "fix next day_name logic";
$match = tpam( "tue" );
$try = Date.new(2017,6,27).DateTime;
ok $match eqv $try, "tue";
# dd $match; dd $try;

$match = tpam( "now + 23 min", now => DateTime.new(1258462020) );
$try = DateTime.new(1258462020).later(:23minute);
ok $match eqv $try, "now + 23 min";

$match = tpam( "next week" );
$try = $now.later(:1week);
ok $match eqv $try, "next week";

throws-like { tpam( "2359 utc" ) }, X::NYI;;
# $try = $now.in-timezone(0);
# ok $match eqv $try, "now utc";

# dd $match; dd $try;
done-testing;
