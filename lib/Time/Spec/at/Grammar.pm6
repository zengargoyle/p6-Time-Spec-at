
use v6.c;
unit module Time::Spec::at::Grammar:ver<0.0.1>:auth<github:zengargoyle>;

grammar At {

  rule TOP { ^^ <timespec> $$ }

  token INT1DIGIT { <[0..9]> }
  token INT2DIGIT { <[0..9]> ** 2 }
  token INT4DIGIT { <[0..9]> ** 4 }
  token INT5_8DIGIT { <[0..9]> ** 5..8 }
  token INT { <INT1DIGIT> + }
  token DOTTEDDATE { <INT1DIGIT> ** 1..2 '.' <INT1DIGIT> ** 1..2 '.' [ <INT4DIGIT> | <INT2DIGIT> ] }
  token HYPHENDATE { [ <INT4DIGIT> | <INT2DIGIT> ] '-' <INT1DIGIT> ** 1..2 '-' <INT1DIGIT> ** 1..2 }
  token HOURMIN { $<hour> = [ <[0..2]> <INT1DIGIT> | <INT1DIGIT> ] <[\:\'h,\.]> $<min> = <INT2DIGIT> }

  token NOW {:i now }
  token AM {:i am }
  token PM {:i pm }
  token NOON {:i noon }
  token MIDNIGHT {:i midnight }
  token TEATIME {:i teatime }
  token SUN {:i sun[day]? }
  token MON {:i mon[day]? }
  token TUE {:i tue[sday]? }
  token WED {:i wed[nesday]? }
  token THU {:i thu[rsday]? }
  token FRI {:i fri[day]? }
  token SAT {:i sat[urday]? }
  token TODAY {:i today }
  token TOMORROW {:i tomorrow }
  token NEXT {:i next }
  token MINUTE {:i min | minute[s]? }
  token HOUR {:i hour[s]? }
  token DAY {:i day[s]? }
  token WEEK {:i week[s]? }
  token MONTH {:i month[s]? }
  token YEAR {:i year[s]? }
  token JAN {:i jan[uary]? }
  token FEB {:i feb[ruary]? }
  token MAR {:i mar[ch]? }
  token APR {:i apr[il]? }
  token MAY {:i may }
  token JUN {:i jun[e]? }
  token JUL {:i jul[y]? }
  token AUG {:i aug[ust]? }
  token SEP {:i sep[tember]? }
  token OCT {:i oct[ober]? }
  token NOV {:i nov[ember]? }
  token DEC {:i dec[ember]? }
  token UTC {:i utc }

  # rule timespec { <spec_base> | <spec_base> <inc_or_dec> }
  # rule timespec { <spec_base> | [ <spec_base> <inc_or_dec> ] }
  rule timespec {
    | <spec_base> <inc_or_dec>
    | <spec_base>
  }
  rule spec_base {
    | <NOW>
    | <time> <date>
    | <time>
    | <date>
  }
  rule time {
    | <time_base> <timezone_name>
    | <time_base>
  }
  rule time_base { 
    | <hr24clock_hr_min> 
    | <time_hour_min> <am_pm> 
    | <time_hour> <am_pm> 
    | <time_hour_min> 
    | <NOON> | <MIDNIGHT> | <TEATIME>
  }
  rule hr24clock_hr_min { <INT4DIGIT> }
  rule time_hour { <int2_2digit> }
  rule time_hour_min { <HOURMIN> }
  rule am_pm { <AM> | <PM> }
  rule timezone_name { <UTC> }
  rule date {
    | <month_name> <day_number> ',' <year_number>
    | <month_name> <day_number> <year_number>
    | <month_name> <day_number>
    | <day_of_week>
    | <TODAY>
    | <TOMORROW>
    | <HYPHENDATE>
    | <DOTTEDDATE>
    | <month_number> '/' <day_number> '/' <year_number>
    | <day_number> <month_name> <year_number>
    | <day_number> <month_name>
    | <concatenated_date>
    | <NEXT> <inc_dec_period>
    | <NEXT> <day_of_week>
  }
  rule concatenated_date { <INT5_8DIGIT> }
  rule month_name { <JAN> | <FEB> | <MAR> | <APR> | <MAY> | <JUN> | <JUL> | <AUG> | <SEP> | <OCT>
    | <NOV> | <DEC>
  }
  rule month_number { <int1_2digit> }
  rule day_number { <int1_2digit> }
  rule year_number { <int2_or_4digit> }
  rule day_of_week { <SUN> | <MON> | <TUE> | <WED> | <THU> | <FRI> | <SAT> }
  rule inc_or_dec { <increment> | <decrement> }
  rule increment { '+' <inc_dec_number> <inc_dec_period> }
  rule decrement { '-' <inc_dec_number> <inc_dec_period> }
  rule inc_dec_number { <integer> }
  rule inc_dec_period { <MINUTE> | <HOUR> | <DAY> | <WEEK> | <MONTH> | <YEAR> }
  rule int1_2digit { <INT2DIGIT> | <INT1DIGIT> }
  rule int2_or_4digit { <INT4DIGIT> | <INT2DIGIT> }
  #rule integer { <INT5_8DIGIT>| <INT4DIGIT> | <INT2DIGIT> | <INT1DIGIT> | <INT> }
  rule integer { <INT> }

}

=begin pod

=head1 NAME

Time::Spec::at::Grammar - a grammar for `at` timespec.

=head1 SYNOPSIS

  use Time::Spec::at::Grammar;

=head1 DESCRIPTION

Time::Spec::at::Grammar is a grammar for `at` timspec.

=head1 AUTHOR

zengargoyle <zengargoyle@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 zengargoyle

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
