
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
    # dd [ 'top', $/<timespec>.made ];
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
        %d = %d, $/<time>.made;
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
      when $/<TODAY>:exists { make { year => $.now.year, month => $.now.month, day => $.now.day } }
      when $/<TOMORROW>:exists {
        my $now = $.now.clone.later: :1day;
        make { year => $now.year, month => $now.month, day => $now.day };
      }
      when $/<NEXT>:exists {
        when $/<inc_dec_period>:exists { ... }
        when $/<day_of_week>:exists { ... }
        default { note 'wut NEXT' }
      }
      when $/<day_of_week>:exists { 
        my $now = $.now.Date;
        my $now-day = $now.day-of-week;
        my $dow = $/<day_of_week>.made;
        given $now-day cmp $dow {
          when Less { $now .= later: day => $dow - $now-day; }
          when More { $now .= earlier: day => $now-day - $dow; $now .= later: :1week; }
        }
        make { year => $now.year, month => $now.month, day => $now.day };
      }
      when $/<concatenated_date>:exists { ... }
      default { note "wut date" }
    }
  }

  method month_name ($/) { make $/.made }
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
