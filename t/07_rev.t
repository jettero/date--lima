
use strict;
use Test;

my @tests = (
    [ 7654321 => '638W1Z1e4m35s' ],
);

use Date::Lima qw/rev/;
plan tests => 1;

my $ds = rev("9h22m5s");

ok($ds, 33_725);
