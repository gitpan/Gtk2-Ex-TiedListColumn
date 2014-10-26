#!/usr/bin/perl

# Copyright 2010 Kevin Ryde

# This file is part of Gtk2-Ex-TiedListColumn.
#
# Gtk2-Ex-TiedListColumn is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3, or (at your option) any
# later version.
#
# Gtk2-Ex-TiedListColumn is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Gtk2-Ex-TiedListColumn.  If not, see <http://www.gnu.org/licenses/>.

package TestWithoutGtk2Methods;
use strict;
use warnings;

sub import {
  my ($class, @functions) = @_;
  my $verbose = 0;
  my $count = 0;

  foreach my $function (@functions) {
    if ($function eq 'verbose') {
      $verbose++;

    } elsif ($function eq 'insert_with_values') {
      require Gtk2;
      print STDERR "TestWithoutGtk2Methods: without ListStore,TreeStore $function per Gtk pre-2.6\n";
      $count++;

      Gtk2::ListStore->can('insert_with_values'); # force autoload
      Gtk2::TreeStore->can('insert_with_values'); # force autoload

      { no warnings 'once';
        undef *Gtk2::ListStore::insert_with_values;
        undef *Gtk2::TreeStore::insert_with_values;
      }

      if (Gtk2::ListStore->can('insert_with_values')) {
        die 'Oops, Gtk2::ListStore can still insert_with_values()';
      }
      if (Gtk2::TreeStore->can('insert_with_values')) {
        die 'Oops, Gtk2::ListStore can still insert_with_values()';
      }

      {
        my $store = Gtk2::ListStore->new ('Glib::String');
        if (eval { $store->insert_with_values(0, 0=>'foo'); 1 }) {
          die 'Oops, Gtk2::ListStore can store->insert_with_values()';
        }
      }
      {
        my $store = Gtk2::TreeStore->new ('Glib::String');
        if (eval { $store->insert_with_values(undef, 0, 0=>'foo'); 1 }) {
          die 'Oops, Gtk2::TreeStore can store->insert_with_values()';
        }
      }

    } else {
      die "Unknown function to disable: $function";
    }
  }
  if ($verbose) {
    print STDERR "TestWithoutGtk2Methods: count $count\n";
  }
}

1;

=head1 NAME

TestWithoutGtk2Methods - disable selected Gtk2 methods for testing

=head1 SYNOPSIS

 perl -MTestWithoutGtk2Methods=insert_with_values foo.t

 use TestWithoutGtk2Methods 'insert_with_values';

=head1 DESCRIPTION

Work in progress ... !

=head1 SEE ALSO

L<Test::Without::Module>

=head1 HOME PAGE

L<http://user42.tuxfamily.org/gtk2-ex-tiedlistcolumn/>

=head1 COPYRIGHT

Copyright 2010 Kevin Ryde

Gtk2-Ex-TiedListColumn is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option) any
later version.

Gtk2-Ex-TiedListColumn is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along with
Gtk2-Ex-TiedListColumn.  If not, see L<http://www.gnu.org/licenses/>.

=cut
