
use v6.c;
use Test;

use Time::Spec::at;
use Time::Spec::at::Grammar;
use Time::Spec::at::Actions;

# set a consistent $now for testing

my $now = DateTime.now;
diag $now;

# helper functions

my sub tpa ($str) {
  Time::Spec::at::Grammar::At.parse(
    $str,
    actions => Time::Spec::at::Actions::AtActions.new(:$now)
  );
}

my sub tpam ($str) { tpa($str).made; }

# tests

my DateTime $match;
my DateTime $try;

# spec_base

$match = tpam( "now" );
ok $match eqv $now, "now";

# # spec_base date

$match = tpam( "01.01.2017" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "dotteddate 01.01.2017";

$match = tpam( "2017-01-01" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "hyphendate 2017-01-01";

$match = tpam( "jan 01 2017" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "jan 01 2017";

$match = tpam( "jan 01, 2017" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "jan 01, 2017";

$match = tpam( "jan 01" );
$try = Date.new($now.year, 1, 1).DateTime;
ok $match eqv $try, "jan 01";

$match = tpam( "01 jan 2017" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "01 jan 2017";

$match = tpam( "01/01/2017" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "01/01/2017";

$match = tpam( "01 / 01 / 2017" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "01 / 01 / 2017";

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
$match = tpam( "mon" );
$try = Date.new(2017,6,27).earlier(:1day).later(:1week).DateTime;
ok $match eqv $try, "mon";
$match = tpam( "tue" );
$try = Date.new(2017,6,27).DateTime;
ok $match eqv $try, "tue";

$match = tpam( "1305" );
$try = $now.clone(:13hour,:5minute);
ok $match eqv $try, "1305";

$match = tpam( "1305 tomorrow" );
$try = $now.clone(:13hour,:5minute,:0second,:0timezone).later(:1day);
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
$try = Date.new(1969,12,8).DateTime;
ok $match eqv $try, "120869";
$match = tpam( "12081969" );
$try = Date.new(1969,12,8).DateTime;
ok $match eqv $try, "120869";

dd $match;
dd $try;

done-testing;
