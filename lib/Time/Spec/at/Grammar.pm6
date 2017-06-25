
use v6.c;
unit class Time::Spec::at::Grammar:ver<0.0.1>:auth<github:zengargoyle>;

grammar At {

  rule TOP { <timespec> }

  token INT1DIGIT { <[0..9]> }
  token INT2DIGIT { <[0..9]> ** 2 }
  token INT4DIGIT { <[0..9]> ** 4 }
  token INT5_8DIGIT { <[0..9]> ** 5..8 }
  token INT { <INT1DIGIT> + }
  token DOTTEDDATE { <INT1DIGIT> ** 1..2 '.' <INT1DIGIT> ** 1..2 '.' [ <INT2DIGIT> | <INT4DIGIT> ] }
  token HYPHENDATE { [ <INT2DIGIT> | <INT4DIGIT> ] '-' <INT1DIGIT> ** 1..2 '-' <INT1DIGIT> ** 1..2 }
  token HOURMIN { [ <[0..2]> <INT1DIGIT> | <INT1DIGIT> ] <[\:\'h,\.]> <INT2DIGIT> }

  token NOW { now }
  token AM { am }
  token PM { pm }
  token NOON { noon }
  token MIDNIGHT { midnight }
  token TEATIME { teatime }
  token SUN { sun[day]? }
  token MON { mon[day]? }
  token TUE { tue[sday]? }
  token WED { wed[nesday]? }
  token THU { thu[rsday]? }
  token FRI { fri[day]? }
  token SAT { sat[urday]? }
  token TODAY { today }
  token TOMORROW { tomorrow }
  token NEXT { next }
  token MINUTE { min | minute[s]? }
  #token MINUTE { min }
  # token MINUTE { minute[s]? }
  token HOUR { hour[s]? }
  token DAY { day[s]? }
  token WEEK { week[s]? }
  token MONTH { month[s]? }
  token YEAR { year[s]? }
  token JAN { jan[uary]? }
  token FEB { feb[ruary]? }
  token MAR { mar[ch]? }
  token APR { apr[il]? }
  token MAY { may }
  token JUN { jun[e]? }
  token JUL { jul[y]? }
  token AUG { aug[ust]? }
  token SEP { sep[tember]? }
  token OCT { oct[ober]? }
  token NOV { nov[ember]? }
  token DEC { dec[ember]? }
  token UTC { utc }

  rule timespec { <spec_base> | <spec_base> <inc_or_dec> }
  rule spec_base { <date> | <time> | <time> <date> | <NOW> }
  rule time { <time_base> | <time_base> <timezone_name> }
  rule time_base { <hr24clock_hr_min> | <time_hour> <am_pm> | <time_hour_min> 
    | <time_hour_min> <am_pm> | <NOON> | <MIDNIGHT> | <TEATIME>
  }
  rule hr24clock_hr_min { <INT4DIGIT> }
  rule time_hour { <int2_2digit> }
  rule time_hour_min { <HOURMIN> }
  rule am_pm { <AM> | <PM> }
  rule timezone_name { <UTC> }
  rule date { <month_name> <day_number> | <month_name> <day_number> <year_number>
    | <month_name> <day_number> ',' <year_number> | <day_of_week> | <TODAY> | <TOMORROW>
    | <HYPENDATE> | <DOTTEDDATE> | <day_number> <month_name> | <day_number> <month_name> <year_number>
    | <month_number> '/' <day_number> '/' <year_number> | <concatenated_date>
    | <NEXT> <inc_dec_period> | <NEXT> <day_of_week>
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
  rule int1_2digit { <INT1DIGIT> | <INT2DIGIT> }
  rule int2_or_4digit { <INT2DIGIT> | <INT4DIGIT> }
  rule integer { <INT> | <INT1DIGIT> | <INT2DIGIT> | <INT4DIGIT> | <INT5_8DIGIT> }
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
