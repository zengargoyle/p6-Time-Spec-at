
use v6.c;
unit class Time::Spec::at::Grammar:ver<0.0.1>:auth<github:zengargoyle>;

grammar At {

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
