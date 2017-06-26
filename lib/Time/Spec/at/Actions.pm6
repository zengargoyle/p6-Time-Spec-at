
use v6.c;
unit module Time::Spec::at::Actions:ver<0.0.1>:auth<github:zengargoyle>;

class AtActions {
  has DateTime $.now is rw = DateTime.now;
  method TOP ($/) { make $.now; }
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
