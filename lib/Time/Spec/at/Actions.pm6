
use v6.c;
unit module Time::Spec::at::Actions:ver<0.0.1>:auth<github:zengargoyle>;

class AtActions {
  has DateTime $.now is rw = DateTime.now;
  has Date $.nowdate is rw = Date.new( $!now );

  method TOP ($/) { make $.now; }

  # NOTE: ugly split, fix later
  method HYPHENDATE ($/) { my ($y,$m,$d) = $/.split('-'); $y += 1900 if $y < 100; $.now = Date.new($y, $m, $d).DateTime; }
  method DOTTEDDATE ($/) { my ($m,$d,$y) = $/.split('.'); $y += 1900 if $y < 100; $.now = Date.new($y, $m, $d).DateTime; }

  method HOURMIN ($/) { $.now .= clone(hour => +$/<hour>, minute => +$/<min>); }

  # method NOW ($/) { make $.now }
  # NOTE: $.now .= clone().truncated-to(); doen't work as i expected. :)
  method NOON     ($/) { $.now = $.now.clone(:12hour).truncated-to('hour'); }
  method TEATIME  ($/) { $.now = $.now.clone(:16hour).truncated-to('hour'); }
  method MIDNIGHT ($/) { $.now =                $.now.truncated-to('day');  }

  method increment ($/) {
    $.now .= later:   |Pair.new($/<inc_dec_period>.made, $/<inc_dec_number>.made);
  }
  method decrement ($/) {
    $.now .= earlier: |Pair.new($/<inc_dec_period>.made, $/<inc_dec_number>.made);
  }

  # method month_name ($/) { make $/.keys.first.lc.Str }
  # method day_of_week ($/) { make $/.keys.first.lc.Str }

  method inc_dec_period ($/) { make $/.keys.first.lc.Str }
  method inc_dec_number ($/) { make $/<integer>.made }
  method integer        ($/) { make +$/<INT> }

  method INT1DIGIT ($/) { make +$/ }
  method INT2DIGIT ($/) { make +$/ }
  method INT4DIGIT ($/) { make +$/ }
  method INT5_8DIGIT ($/) { make +$/ }

  method time_hour ($/) { $.now .= clone( hour => +$/ ); }
  # method time_hour_min ($/) { $.now .= clone( hour => +$/ ); }
  method PM ($/) { $.now = $.now.hour < 12 ?? $.now.later(:12hour) !! $.now; }

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
