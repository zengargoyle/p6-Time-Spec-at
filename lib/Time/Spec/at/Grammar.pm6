
use v6.c;
unit class Time::Spec::at::Grammar:ver<0.0.1>:auth<github:zengargoyle>;

# /* 
#  * Abbreviated version of the yacc grammar used by at(1).
#  */

# %token  <charval> DOTTEDDATE
# %token  <charval> HYPHENDATE
# %token  <charval> HOURMIN
# %token  <charval> INT1DIGIT
# %token  <charval> INT2DIGIT
# %token  <charval> INT4DIGIT
# %token  <charval> INT5_8DIGIT
# %token  <charval> INT
# %token  NOW
# %token  AM PM
# %token  NOON MIDNIGHT TEATIME
# %token  SUN MON TUE WED THU FRI SAT
# %token  TODAY TOMORROW
# %token  NEXT
# %token  MINUTE HOUR DAY WEEK MONTH YEAR
# %token  JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC
# %token  UTC

# %type <charval> concatenated_date
# %type <charval> hr24clock_hr_min
# %type <charval> int1_2digit
# %type <charval> int2_or_4digit
# %type <charval> integer
# %type <intval> inc_dec_period
# %type <intval> inc_dec_number
# %type <intval> day_of_week

# %start timespec
# %%
# timespec        : spec_base
# 		| spec_base inc_or_dec
#                 ;

grammar At {
  rule TOP { <timespec> }
  rule timespec { 
    | <spec-base>
    | <spec-base> <inc-or-dec>
  }

# spec_base	: date
# 		| time
#                 | time date
#                 | NOW
# 		;

  rule spec-base {
    | <time>
    | <time> <date>
    | <now>
  }
# time		: time_base
# 		| time_base timezone_name
#                 ;

  rule time {
    | <time-base>
    | <time-base> <timezone-name>
  }

# time_base	: hr24clock_hr_min
# 		| time_hour am_pm
# 		| time_hour_min
# 		| time_hour_min am_pm
# 		| NOON
#                 | MIDNIGHT
# 		| TEATIME
# 		;

  rule time-base {
    | <hr24clock-hr-min>
    | <time-hour> <am-pm>
    | <time-hour-min>
    | <time-hour-min> <am-pm>
    | <noon>
    | <midnight>
    | <teatime>
  }

# hr24clock_hr_min: INT4DIGIT
# 		;

  rule h24clock-hr-min { <[0..9]> ** 4 }

# time_hour	: int1_2digit
# 		;

  rule time-hour { <[0..9]> ** 2 }

# time_hour_min	: HOURMIN
# 		;

  rule time-hour-min { <[0..9]> ** 2 ':' <[0..9]> ** 2 }

# am_pm		: AM
# 		| PM
# 		;

  rule am-pm { 'am' | 'pm' | 'a.m.' | 'p.m.' }

# timezone_name	: UTC
# 		;

  rule timezone-name { 'utc' }

# date            : month_name day_number
#                 | month_name day_number year_number
#                 | month_name day_number ',' year_number
#                 | day_of_week
#                 | TODAY
#                 | TOMORROW
# 		| HYPHENDATE
# 		| DOTTEDDATE
# 		| day_number month_name
# 		| day_number month_name year_number
# 		| month_number '/' day_number '/' year_number
# 		| concatenated_date
#                 | NEXT inc_dec_period		
# 		| NEXT day_of_week
#                 ;

# concatenated_date: INT5_8DIGIT
# 		;

# month_name	: JAN | FEB | MAR | APR | MAY | JUN
# 		| JUL | AUG | SEP | OCT | NOV | DEC
# 		;

# month_number	: int1_2digit
# 		;

# day_number	: int1_2digit
# 		;

# year_number	: int2_or_4digit
# 		;

# day_of_week	: SUN | MON | TUE | WED | THU | FRI | SAT
# 		;

# inc_or_dec	: increment | decrement
# 		;

# increment       : '+' inc_dec_number inc_dec_period
#                 ;

# decrement	: '-' inc_dec_number inc_dec_period
# 		;

# inc_dec_number	: integer
# 		;

# inc_dec_period	: MINUTE | HOUR | DAY | WEEK | MONTH | YEAR
# 		;

# int1_2digit	: INT1DIGIT | INT2DIGIT
# 		;

# int2_or_4digit	: INT2DIGIT | INT4DIGIT
# 		;

# integer		: INT | INT1DIGIT | INT2DIGIT | INT4DIGIT | INT5_8DIGIT
# 		;

# %%

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
