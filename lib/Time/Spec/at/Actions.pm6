
use v6.c;
unit module Time::Spec::at::Actions:ver<0.0.1>:auth<github:zengargoyle>;

class AtActions {

  has DateTime $.now is rw = DateTime.now;

  my sub dt2h ($dt) {
    return {
      year => $dt.year,
      month => $dt.month,
      day => $dt.day,
      hour => $dt.hour,
      minute => $dt.minute,
      second => $dt.second,
      timezone => $dt.timezone,
    }
  }

  method TOP ($/) {
    make $/<timespec>.made;
  }

  method timespec ($/) {
    my $dt = DateTime.new: |$/<spec_base>.made;
    if $/<inc_or_dec>:exists {
      given $/<inc_or_dec> {
        when $_<increment>:exists {
          $dt .= later: |($_<increment><inc_dec_period>.made => $_<increment><inc_dec_number>.made); 
        }
        when $_<decrement>:exists {
          $dt .= earlier: |($_<decrement><inc_dec_period>.made => $_<decrement><inc_dec_number>.made); 
        }
        default { note 'wut timespec' }
      }
    }
    make $dt;
  }
  method spec_base ($/) {
  given $/ {
      when $/<NOW>:exists { make dt2h( $.now ) }

      # <time> <date>?  -- must check <time> before just <date>
      when $/<time>:exists {
        my %d = $/<date>:exists ?? $/<date>.made !! dt2h($.now);
        # %d<second timezone>:delete;  # XXX second and timezone not really supported well yet
        %d ,= $/<time>.made;
        make %d;
      }

      when $/<date>:exists { make $/<date>.made }

      default { note "wut spec_base" }
    }
  }

  method time ($/) { make $/<time_base>.made }

  method time_base ($/) {
    given $/ {
      when $/<hr24clock_hr_min>:exists { make $/<hr24clock_hr_min>.made }

      when $/<time_hour_min>:exists or $/<time_hour>:exists {
        my %r = $/<time_hour_min><HOURMIN>.made // hour => +$/<time_hour>;
        %r<hour> += 12 if %r<hour> < 12 and $/<am_pm><PM>:exists;
        %r<hour> = 0 if %r<hour> == 12 and $/<am_pm><AM>:exists;
        make %r;
      }

      when $/<NOON> { make { :12hour, :0minute } }
      when $/<MIDNIGHT> { make { :0hour, :0minute } }
      when $/<TEATIME> { make { :16hour, :0minute } }
    }
  }

  method date ($/) {
    given $/ {

      when $/<HYPHENDATE>:exists { make $/<HYPHENDATE>.made; }
      when $/<DOTTEDDATE>:exists { make $/<DOTTEDDATE>.made; }

      when $/<month_name>:exists {
        my %r =
          month => $/<month_name>.made,
          day => $/<day_number>.made,
        ;
        if $/<year_number> -> $m { %r<year> = $m.made }
        else { %r<year> = $.now.year }
        make %r;
      }

      when $/<month_number>:exists {
        my %r =
          month => $/<month_number>.made,
          day => $/<day_number>.made,
          year => $/<year_number>.made,
        ;
        make %r;
      }

      when $/<TODAY>:exists {
        make { year => $.now.year, month => $.now.month, day => $.now.day };
      }
      when $/<TOMORROW>:exists {
        my $now = $.now.clone.later: :1day;
        make { year => $now.year, month => $now.month, day => $now.day };
      }

      sub next-day-of-week( $day ) {
        my $now = $.now.Date;
        my $now-day = $now.day-of-week;
        my $dow = $day;
        given $now-day cmp $dow {
          when Less { $now .= later: day => $dow - $now-day; }
          when More { $now .= earlier: day => $now-day - $dow; $now .= later: :1week; }
        }
        return { year => $now.year, month => $now.month, day => $now.day };
      }

      when $/<NEXT>:exists {
        when $/<inc_dec_period>:exists {
          my $n = $.now.later(|%( $/<inc_dec_period>.made, 1));
          make dt2h($n);
        }
        when $/<day_of_week>:exists { make next-day-of-week( $/<day_of_week>.made ) }
        default { note 'wut NEXT' }
      }

      when $/<day_of_week>:exists { 
        make next-day-of-week( $/<day_of_week>.made );
      }

      when $/<concatenated_date>:exists { make $/<concatenated_date>.made }

      default { note "wut date" }
    }
  }

  method concatenated_date ($/) {
      my ($month, $day, $year) = $/.substr(0,2), $/.substr(2,2), $/.substr(4);
      $year += 1900 if $year < 70;
      $year += 2000 if 70 < $year < 100;  # XXX need some YY -> YYYY logic all over the place.
      make { :$month, :$day, :$year };
  }

  method inc_dec_period:sym<MINUTE> ($/) { make 'minute' }
  method inc_dec_period:sym<HOUR> ($/) { make 'hour' };
  method inc_dec_period:sym<DAY> ($/) { make 'day' };
  method inc_dec_period:sym<WEEK> ($/) { make 'week' };
  method inc_dec_period:sym<MONTH> ($/) { make 'month' };
  method inc_dec_period:sym<YEAR> ($/) { make 'year' };

  method day_of_week:sym<SUN> ($/) { make 7 };
  method day_of_week:sym<MON> ($/) { make 1 };
  method day_of_week:sym<TUE> ($/) { make 2 };
  method day_of_week:sym<WED> ($/) { make 3 };
  method day_of_week:sym<THU> ($/) { make 4 };
  method day_of_week:sym<FRI> ($/) { make 5 };
  method day_of_week:sym<SAT> ($/) { make 6 };

  method month_name:sym<JAN> ($/) { make 1 };
  method month_name:sym<FEB> ($/) { make 2 };
  method month_name:sym<MAR> ($/) { make 3 };
  method month_name:sym<APR> ($/) { make 4 };
  method month_name:sym<MAY> ($/) { make 5 };
  method month_name:sym<JUN> ($/) { make 6 };
  method month_name:sym<JUL> ($/) { make 7 };
  method month_name:sym<AUG> ($/) { make 8 };
  method month_name:sym<SEP> ($/) { make 9 };
  method month_name:sym<OCT> ($/) { make 10 };
  method month_name:sym<NOV> ($/) { make 11 };
  method month_name:sym<DEC> ($/) { make 12 };

  method integer ($/) { make +$/ }
  method inc_dec_number ($/) { make $/<integer>.made }
  method month_number ($/) { make +$/ }
  method day_number ($/) { make +$/ }
  method year_number ($/) { make +$/ }

  method DOTTEDDATE ($/) {
    { make { year => +$/<year>, month => +$/<month>, day => +$/<day> } }
  }
  method HYPHENDATE ($/) {
    { make { year => +$/<year>, month => +$/<month>, day => +$/<day> } }
  }
  method HOURMIN ($/) {
    { make { hour => +$/<hour>, minute => +$/<minute> } }
  }
  method hr24clock_hr_min ($/) {
    make { hour => $/.substr(0,2), minute => +$/.substr(2,2) };
  }

}

=begin pod

=head1 NAME

Time::Spec::at::Actions - actions for `at` timespec.

=head1 SYNOPSIS

  use Time::Spec::at::Actions;

=head1 DESCRIPTION

Time::Spec::at::Actions is actionss for `at` timspec.

=head1 AUTHOR

zengargoyle <zengargoyle@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 zengargoyle

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
