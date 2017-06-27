
use v6.c;
unit module Time::Spec::at::Grammar:ver<0.0.1>:auth<github:zengargoyle>;

grammar At {

  rule TOP { ^^ <timespec> $$ }

  token INT1DIGIT { <[0..9]> { make +$/ } }
  token INT2DIGIT { <[0..9]> ** 2 { make +$/ } }
  token INT4DIGIT { <[0..9]> ** 4 { make +$/ } }
  token INT5_8DIGIT { <[0..9]> ** 5..8 { make +$/ } }
  token INT { <.INT1DIGIT> + { make +$/ } }
  token DOTTEDDATE {
    $<month>=[ <.INT1DIGIT> ** 1..2 ] '.'
    $<day>=[ <.INT1DIGIT> ** 1..2 ] '.'
    $<year>=[ <.INT4DIGIT> | <.INT2DIGIT> ]
    { make { year => +$/<year>, month => +$/<month>, day => +$/<day> } }
  }
  token HYPHENDATE {
    $<year>=[ <.INT4DIGIT> | <.INT2DIGIT> ] '-'
    $<month>=[ <.INT1DIGIT> ** 1..2 ] '-'
    $<day>=[ <.INT1DIGIT> ** 1..2 ]
    { make { year => +$/<year>, month => +$/<month>, day => +$/<day> } }
  }
  token HOURMIN {
    $<hour>=[ <[0..2]> <.INT1DIGIT> | <.INT1DIGIT> ] <[\:\'h,\.]>
    $<minute>=[<.INT2DIGIT>]
    { make { hour => +$/<hour>, minute => +$/<minute> } }
  }

  token AM {:i am }
  token PM {:i pm }

  token NOW {:i now }
  token NOON {:i noon }
  token MIDNIGHT {:i midnight }
  token TEATIME {:i teatime }

  token TODAY {:i today }
  token TOMORROW {:i tomorrow }

  proto token day_of_week { * }
  token day_of_week:sym<SUN> {:i sun[day]? { make 7 } }
  token day_of_week:sym<MON> {:i mon[day]? { make 1 } }
  token day_of_week:sym<TUE> {:i tue[sday]? { make 2 } }
  token day_of_week:sym<WED> {:i wed[nesday]? { make 3 } }
  token day_of_week:sym<THU> {:i thu[rsday]? { make 4 } }
  token day_of_week:sym<FRI> {:i fri[day]? { make 5 } }
  token day_of_week:sym<SAT> {:i sat[urday]? { make 6 } }

  proto token inc_dec_period { * }
  token inc_dec_period:sym<MINUTE> {:i min | minute[s]? { make 'minute' } }
  token inc_dec_period:sym<HOUR> {:i hour[s]? { make 'hour' } }
  token inc_dec_period:sym<DAY> {:i day[s]? { make 'day' } }
  token inc_dec_period:sym<WEEK> {:i week[s]? { make 'week' } }
  token inc_dec_period:sym<MONTH> {:i month[s]? { make 'month' } }
  token inc_dec_period:sym<YEAR> {:i year[s]? { make 'year' } }

  proto token month_name { * }
  token month_name:sym<JAN> {:i jan[uary]? { make 1 } }
  token month_name:sym<FEB> {:i feb[ruary]? { make 2 } }
  token month_name:sym<MAR> {:i mar[ch]? { make 3 } }
  token month_name:sym<APR> {:i apr[il]? { make 4 } }
  token month_name:sym<MAY> {:i may { make 5 } }
  token month_name:sym<JUN> {:i jun[e]? { make 6 } }
  token month_name:sym<JUL> {:i jul[y]? { make 7 } }
  token month_name:sym<AUG> {:i aug[ust]? { make 8 } }
  token month_name:sym<SEP> {:i sep[tember]? { make 9 } }
  token month_name:sym<OCT> {:i oct[ober]? { make 10 } }
  token month_name:sym<NOV> {:i nov[ember]? { make 11 } }
  token month_name:sym<DEC> {:i dec[ember]? { make 12 } }

  token NEXT {:i next }
  token UTC {:i utc }

  rule timespec { <spec_base> <inc_or_dec>? }

  rule spec_base {
    | <NOW>
    # 01.01.2017 and 2107-01-01 will match time_hr_min and hr24clock_hr_min
    # so <date> before <time>
    | <date>
    | <time> <date>?
  }

  rule time { <time_base> <timezone_name>? }

  rule time_base { 
    | <hr24clock_hr_min> 
    | <time_hour_min> <am_pm>? 
    | <time_hour> <am_pm> 
    | <NOON> | <MIDNIGHT> | <TEATIME>
  }
  rule hr24clock_hr_min { <.INT4DIGIT> { make { hour => $/.substr(0,2), minute => +$/.substr(2,2) } } }
  rule time_hour { <int1_2digit> }
  rule time_hour_min { <HOURMIN> }
  rule am_pm { <AM> | <PM> }
  rule timezone_name { <UTC> }
  rule date {
    | <month_name> <day_number> ','? <year_number>?
    # | <month_name> <day_number> <year_number>
    # | <month_name> <day_number>
    | <day_of_week>
    | <TODAY>
    | <TOMORROW>
    | <DOTTEDDATE>
    | <HYPHENDATE>
    | <month_number> '/' <day_number> '/' <year_number>
    | <day_number> <month_name> <year_number>?
    # | <day_number> <month_name>
    | <concatenated_date>
    | <NEXT> <inc_dec_period>
    | <NEXT> <day_of_week>
  }
  rule concatenated_date { <INT5_8DIGIT> }
  rule month_number { <int1_2digit> { make +$/ } }
  rule day_number { <.int1_2digit> { make +$/ } }
  rule year_number { <.int2_or_4digit> { make +$/ } }
  rule inc_or_dec { <increment> | <decrement> }
  rule increment { '+' <inc_dec_number> <inc_dec_period> }
  rule decrement { '-' <inc_dec_number> <inc_dec_period> }
  rule inc_dec_number { <integer> { make $/<integer>.made } }
  rule int1_2digit { <.INT2DIGIT> | <.INT1DIGIT> }
  rule int2_or_4digit { <.INT4DIGIT> | <.INT2DIGIT> }
  rule integer { <.INT> { make +$/ } }

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
