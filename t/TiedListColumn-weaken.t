#!/usr/bin/perl -w

# Copyright 2008, 2009, 2010 Kevin Ryde

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

use strict;
use warnings;
use Gtk2::Ex::TiedListColumn;
use Test::More;

use lib 't';
use MyTestHelpers;
BEGIN { MyTestHelpers::nowarnings() }

# Test::Weaken 2.000 for leaks(), but 3.001 better as descends into the tied
# object ...
#
eval "use Test::Weaken 2.000; 1"
  or plan skip_all => "due to Test::Weaken 2.000 not available -- $@";
plan tests => 2;

diag ("Test::Weaken version ", Test::Weaken->VERSION);
require Gtk2;
MyTestHelpers::glib_gtk_versions();

#------------------------------------------------------------------------------

{
  my $leaks = Test::Weaken::leaks
    (sub {
       my $store = Gtk2::ListStore->new ('Glib::String');
       my @array;
       tie @array, 'Gtk2::Ex::TiedListColumn', $store;
       return [ \@array, $store ];
     });
  is ($leaks, undef, 'deep garbage collection - array var');
  if ($leaks && defined &explain) {
    diag "Test-Weaken ", explain $leaks;
  }
}{
  my $leaks = Test::Weaken::leaks
    (sub {
       my $store = Gtk2::ListStore->new ('Glib::String');
       my $aref = Gtk2::Ex::TiedListColumn->new ($store);
       return [ $aref, $store ];
     });
  is ($leaks, undef, 'deep garbage collection - arrayref');
  if ($leaks && defined &explain) {
    diag "Test-Weaken ", explain $leaks;
  }
}

exit 0;
