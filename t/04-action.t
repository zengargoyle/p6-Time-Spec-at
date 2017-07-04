
use v6.c;
use Test;

use Time::Spec::at;
use Time::Spec::at::Grammar;
use Time::Spec::at::Actions;

# set a consistent $now for testing

my $now = DateTime.now;
diag $now;

# helper functions

my sub tpa ($str, :$now) {
  Time::Spec::at::Grammar::At.parse(
    $str,
    actions => Time::Spec::at::Actions::AtActions.new(:$now)
  );
}

my sub tpam ($str, :$now = UNIT::<$now>) { tpa($str, :$now).made; }

# tests

my DateTime $match;
my DateTime $try;

# Test with both a DateTime.now object, and truncated like `at`
run-tests();
$now .= clone(:0second,:0timezone);
run-tests();

# Our NYI case....

throws-like { tpam( "2359 utc" ) }, X::NYI;

done-testing;


sub run-tests() {
# spec_base

$match = tpam( "now" );
ok $match eqv $now, "now";

# # spec_base date

$match = tpam( "01.01.2017" );
$try = $now.clone(:2017year, :1month, :1day);
ok $match eqv $try, "dotteddate 01.01.2017";

$match = tpam( "2017-01-01" );
$try = $now.clone(:2017year, :1month, :1day);
ok $match eqv $try, "hyphendate 2017-01-01";

$match = tpam( "jan 01 2017" );
$try = $now.clone(:2017year, :1month, :1day);
ok $match eqv $try, "jan 01 2017";

$match = tpam( "jan 01" );
$try = $now.clone(:2017year, :1month, :1day);
ok $match eqv $try, "jan 01";

$match = tpam( "01 jan 2017" );
$try = $now.clone(:2017year, :1month, :1day);
ok $match eqv $try, "01 jan 2017";

$match = tpam( "01/01/2017" );
$try = $now.clone(:2017year, :1month, :1day);
ok $match eqv $try, "01/01/2017";

$match = tpam( "01 / 01 / 2017" );
$try = $now.clone(:2017year, :1month, :1day);
ok $match eqv $try, "01 / 01 / 2017";

$match = tpam( "today" );
ok $match eqv $now, "today";

$match = tpam( "tomorrow" );
$try = $now.clone.later(:1day);
ok $match eqv $try, "tomorrow";

# Use a specific date for day_of_week tests
$match = tpam( "wed", now => $now.clone(:2017year,:6month,:27day) );
$try = $now.clone(:2017year,:6month,:27day).later(:1day);
ok $match eqv $try, "wed";

$match = tpam( "mon", now => $now.clone(:2017year,:6month,:27day) );
$try = $now.clone(:2017year,:6month,:27day).earlier(:1day).later(:1week);
ok $match eqv $try, "mon";

$match = tpam( "tue", now => $now.clone(:2017year,:6month,:27day) );
$try = $now.clone(:2017year,:6month,:27day);
ok $match eqv $try, "tue";

$match = tpam( "1305" );
$try = $now.clone(:13hour,:5minute);
ok $match eqv $try, "1305";

$match = tpam( "1305 tomorrow" );
$try = $now.clone(:13hour,:5minute).later(:1day);
ok $match eqv $try, "1305 tomorrow";

$match = tpam( "1:05" );
$try = $now.clone(:1hour,:5minute);
ok $match eqv $try, "1:05";

$match = tpam( "1:05 pm" );
$try = $now.clone(:13hour,:5minute);
ok $match eqv $try, "1:05 pm";

$match = tpam( "12:05 am" );
$try = $now.clone(:0hour,:5minute);
ok $match eqv $try, "12:05 am";

$match = tpam( "1 pm" );
$try = $now.clone(:13hour);
ok $match eqv $try, "1 pm";

$match = tpam( "12 am" );
$try = $now.clone(:0hour);
ok $match eqv $try, "12 am";

$match = tpam( "noon" );
$try = $now.clone(:12hour, :0minute);
ok $match eqv $try, "noon";

$match = tpam( "midnight" );
$try = $now.clone(:0hour, :0minute);
ok $match eqv $try, "midnight";

$match = tpam( "teatime" );
$try = $now.clone(:16hour, :0minute);
ok $match eqv $try, "teatime";

$match = tpam( "now + 1 day" );
$try = $now.later(:1day);
ok $match eqv $try, "now + 1 day";
$match = tpam( "now - 1 day" );
$try = $now.earlier(:1day);
ok $match eqv $try, "now - 1 day";

$match = tpam( "120869" );
$try = $now.clone(:1969year,:12month,:8day);
ok $match eqv $try, "120869";

$match = tpam( "12081969" );
$try = $now.clone(:1969year,:12month,:8day);
ok $match eqv $try, "120869";

$match = tpam( "next week" );
$try = $now.later(:1week);
ok $match eqv $try, "next week";

# same as just day_of_week
$match = tpam( "next mon", now => $now.clone(:2017year,:6month,:27day) );
$try = $now.clone(:2017year,:6month,:27day).earlier(:1day).later(:1week);
ok $match eqv $try, "next mon";

# dd $match;
# dd $try;
} # run-tests()

