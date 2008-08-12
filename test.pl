END {print "ok 1\n" if $loaded;}

use Date::Lima qw/beek_date/;

$loaded = 1;

for $i (25, 85, 300, 6000, 7654, 10000, 7654321) {
    printf "\%7d seconds: \%s\n", $i, beek_date($i);
}
