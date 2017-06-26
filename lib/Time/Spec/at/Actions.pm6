
use v6.c;
unit module Time::Spec::at::Actions:ver<0.0.1>:auth<github:zengargoyle>;

class AtActions {
  has DateTime $.now = DateTime.now;

  method TOP ($/) {
    make $/<timespec>.made;
  }

  method timespec ($/) {
    my $dt = $/<spec_base>.made;
    if $/<inc_or_dec><increment>.made -> $delta {
      $dt.=later: |$delta;
    }
    elsif $/<inc_or_dec><decrement>.made -> $delta {
      $dt.=earlier: |$delta;
    }
    make $dt;;
  }

  method spec_base ($/) { make $/.values.first.made }

  method time ($/) { dd DateTime.new: |$/<time_base>.made.hash; }

  method time_base ($/) { make $/.values.first.made; }
  method time_hour_min ($/) { make $/<HOURMIN>.made; }
  method HOURMIN ($/) { make (hour => +$/<hour>, minute => +$/<min>); }

  method NOW ($/) { make $.now }

  # method inc_or_dec ($/) { }
  method increment ($/) {
    make $/<inc_dec_period>.made => +$/<inc_dec_number>.made;
  }
  method decrement ($/) {
    make $/<inc_dec_period>.made => +$/<inc_dec_number>.made;
  }

  method month_name ($/) { make $/.keys.first.lc.Str }
  method day_of_week ($/) { make $/.keys.first.lc.Str }
  method inc_dec_period ($/) { make $/.keys.first.lc.Str }
  method inc_dec_number ($/) { make $/<integer>.made }
  method integer ($/) { make +$/<INT> }

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
