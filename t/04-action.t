
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
#$try = $now.clone(day=>1,month=>1,timezone=>0).truncated-to('day');
$try = Date.new($now.year, 1, 1).DateTime;
ok $match eqv $try, "jan 01";

$match = tpam( "01 jan 2017" );
$try = Date.new("2017-01-01").DateTime;
ok $match eqv $try, "01 jan 2017";

done-testing;
