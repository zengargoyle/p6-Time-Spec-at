
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
    make DateTime.new: |$/<timespec>.made;
  }
  method timespec ($/) {
    make $/<spec_base>.made;
  }
  method spec_base ($/) {
    given $/ {
      when $/<NOW>:exists { make dt2h( $.now ) }
      # <time> <date>?  -- must check <time> before just <date>
      when $/<time>:exists { dd $/<time>; } #make $/<time>.made }
      when $/<date>:exists { make $/<date>.made }
      default { note "wut spec_base" }
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
