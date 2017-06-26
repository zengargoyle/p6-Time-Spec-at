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

my sub tpa ($str) {
  Time::Spec::at::Grammar::At.parse(
    $str,
    actions => Time::Spec::at::Actions::AtActions.new(:$now)
  );
}
my sub tpam ($str) { tpa($str).made; }

$match = tpam( "now" );
ok $match eqv $now, "now is now";

$match = tpam( "now + 1 day" );
ok $match eqv $now.later(days=>1), "now + 1 day";
$match = tpam( "now + 1 year" );
ok $match eqv $now.later(years=>1), "now + 1 year";

$match = tpam( "now - 1 day" );
ok $match eqv $now.earlier(days=>1), "now - 1 day";
$match = tpam( "now - 1 year" );
ok $match eqv $now.earlier(years=>1), "now - 1 year";

$match = tpam( "12:01" );
$try = $now.clone(:12hour,:1minute);
ok $match eqv $try, "12:01";

$match = tpam( "12:01 + 1 year" );
$try = $now.clone(:12hour,:1minute).later(:1year);
ok $match eqv $try, "12:01 + 1 year";

$match = tpam( "noon" );
$try = $now.clone(:12hour,:0minute, :0second);
ok $match eqv $try, "noon";

$match = tpam( "midnight" );
$try = $now.clone(:0hour,:0minute, :0second);
ok $match eqv $try, "midnight";

$match = tpam( "teatime" );
$try = $now.clone(:16hour,:0minute,:0second);
ok $match eqv $try, "teatime";

$match = tpam( "1969-12-08" );
$try = Date.new('1969-12-08').DateTime;
ok $match eqv $try, "hyphendate 1969-12-08";

$match = tpam( "1969-12-08 + 1 min" );
$try = Date.new('1969-12-08').DateTime.later(:1minute);
ok $match eqv $try, "hyphendate 1969-12-08 + 1 min";

$match = tpam( "12.08.1969 + 1 min" );
$try = Date.new('1969-12-08').DateTime.later(:1minute);
ok $match eqv $try, "dotteddate 12.08.1969 + 1 min";

$match = tpam( "12.08.69 + 1 min" );
$try = Date.new('1969-12-08').DateTime.later(:1minute);
ok $match eqv $try, "dotteddate 12.08.69 + 1 min";

done-testing;
