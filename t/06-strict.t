
use v6.c;
use Test;

use Time::Spec::at;
use Time::Spec::at::Grammar;
use Time::Spec::at::Actions;
use DateTime::Format;

sub strptime($string, $format = Nil) {

  state %month-for =
    jan => 1, feb => 2, mar => 3, apr => 4, may => 5, jun => 6,
    jul => 7, aug => 8, sep => 9, oct => 10, nov => 11, dec => 12;

  given $string ~~ m:s/ \w+ $<month>=[\w+] $<day>=[\d+] $<hour>=[\d+] ':' $<minute>=[\d+] ':' $<second>=[\d+] $<year>=[\d**4] / {
    my ($year,$day,$hour,$minute,$second) = %()<year day hour minute second>>>.Int;
    my $month = %month-for{$/<month>.lc};
    # dd $year,$month,$day,$hour,$minute,$second;
    DateTime.new: :$year,:$month,:$day,:$hour,:$minute,:$second
  }
}

# set a consistent $now for testing

my $now = DateTime.new(1258462020);
diag $now;

is strptime("Tue Nov 17 12:47:00 2009", "%a %b %d %T %Y"), $now, "parsed a time string";

sub test($timespec, $expected, $test-name = "{$UNIT::now}: $timespec") {
  my $dt = tpam( $timespec, now => $UNIT::now );
  is $dt, strptime($expected), $test-name;
}
# helper functions

my sub tpa ($str, :$now) {
  Time::Spec::at::Grammar::At.parse(
    $str,
    actions => Time::Spec::at::Actions::AtActions.new(:$now, :strict)
  );
}

my sub tpam ($str, :$now = UNIT::<$now>) { tpa($str, :$now).made; }

# tests

# now, + relative
test("now", "Tue Nov 17 12:47:00 2009");
test("now + 1 min", "Tue Nov 17 12:48:00 2009");
test("now + 23 min", "Tue Nov 17 13:10:00 2009");
test("now + 1 hour", "Tue Nov 17 13:47:00 2009");
test("now + 23 hours", "Wed Nov 18 11:47:00 2009");
test("now + 1 day", "Wed Nov 18 12:47:00 2009");
test("now + 1 week", "Tue Nov 24 12:47:00 2009");
test("now + 1 month", "Thu Dec 17 12:47:00 2009");
test("now + 1 year", "Wed Nov 17 12:47:00 2010");

# later this day, + relative
test("23:55", "Tue Nov 17 23:55:00 2009");
test("23:55 + 7 min", "Wed Nov 18 00:02:00 2009");

# earlier this day, + relative
test("12:00", "Wed Nov 18 12:00:00 2009");
test("12:00 + 5 min", "Wed Nov 18 12:05:00 2009");
todo "time in past + relative time ending up in future";
test("12:00 + 2 hours", "Wed Nov 18 14:00:00 2009");

# date in the future
test("12:00 Dec 17", "Thu Dec 17 12:00:00 2009");

# date in the past
test("12:00 Oct 17", "Sun Oct 17 12:00:00 2010");
test("12:00 Oct 17 + 7 days", "Sun Oct 24 12:00:00 2010");
todo "date in past + relative time ending up in future";
test("12:00 Oct 17 + 35 days", "Sun Nov 21 12:00:00 2010");

# going into the next year
test("00:00 Dec 24", "Thu Dec 24 00:00:00 2009");
test("00:00 Dec 24 + 31 days", "Sun Jan 24 00:00:00 2010");
test("00:00 Dec 24 + 358 days", "Fri Dec 17 00:00:00 2010");

test("23:55 Dec 31", "Thu Dec 31 23:55:00 2009");
test("23:55 Dec 31 + 7 minutes", "Fri Jan  1 00:02:00 2010");

# invalid dates
# todo "Jan 32 is an invalid date";
# test("Jan 32", "Ooops...");

# todo "Feb 30 is an invalid date";
# test("Feb 30", "Ooops...");
# todo "Apr 31 is an invalid date";
# test("Apr 31", "Ooops...");
# todo "more invalid dates", 2;
# test("May -1", "Ooops...");
# test("Oct 0", "Ooops...");

# http://bugs.debian.org/364975
# todo "DST ignored when computing difference from UTC";
# $ENV{TZ} = "America/New_York";
# $now = 1146160800; # Apr 27 2006 18:00 UTC
# test("20:00 UTC", "Thu Apr 27 16:00:00 2006");

done-testing;
