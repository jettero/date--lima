package Date::Lima;

require 5.005_62;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(beek_date set_pre_element_string set_post_element_string) ] ); 
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );
our $VERSION = '1.2';

my %trans;

$trans{'year'} = 52*7*24*60*60; # This was qi3ber's idea.
$trans{'week'} =    7*24*60*60; # I briefly considered changing it, 
$trans{'day'}  =      24*60*60; # but the overhead is very small.
$trans{'hour'} =         60*60; # Plus, if you're using something like
$trans{'min'}  =            60; # modperl you won't feel it anyway. -jet

my $pre  = "";
my $post = "";

return 1;

sub set_pre_element_string  { $pre  = shift; }
sub set_post_element_string { $post = shift; }

sub to_secs {
    my $time = shift;
    my $secs = 0;

    if ( $time =~ m/(\d+):(\d\d):(\d\d)/ ) {
        $secs  = $3;
        $secs += $2 * 60;
        $secs += $1 * 60 * 60;
    } elsif ( $time =~ m/(\d+):(\d\d)/ ) {
        $secs  = $2;
        $secs += $1 * 60;
    } else {
        $secs  = $time;
        print $secs;
    }

    return $secs;
}

sub beek_date {
    my $duration = shift;

    my ( $year, $week, $day, $hour, $min, $sec );

    if ( $duration =~ m/:/ ) {
        $sec = &to_secs($duration);
    } else {
        $sec = $duration;
    }

    $year = int( $sec / $trans{'year'} ); $sec -= $year * $trans{'year'};
    $week = int( $sec / $trans{'week'} ); $sec -= $week * $trans{'week'};
    $day  = int( $sec / $trans{'day'}  ); $sec -= $day  * $trans{'day'};
    $hour = int( $sec / $trans{'hour'} ); $sec -= $hour * $trans{'hour'};
    $min  = int( $sec / $trans{'min'}  ); $sec -= $min  * $trans{'min'};

    my $ret = "";

    $ret .= "$pre$year"."y$post" if $year;
    $ret .= "$pre$week"."w$post" if $week;
    $ret .= "$pre$day" ."d$post" if $day;
    $ret .= "$pre$hour"."h$post" if $hour;
    $ret .= "$pre$min" ."m$post" if $min;
    $ret .= "$pre$sec" ."s$post" if $sec;

    return $ret ? $ret : "$pre"."0s$post";
}

__END__

=head1 NAME

Date::Lima Perl extension for dates like those from conv_date() in the Lima mudlib (2d4h1m4s).

=head1 A brief example

=head2 Simple

    use Date::Lima qw/beek_date/;

    for $i (25, 85, 300, 6000, 7654, 10000, 7654321) {
        printf "\%7d seconds: \%s\n", $i, beek_date($i);
    }

=head2 Webified

    use Date::Lima qw/:all/;
    use CGI qw/:html/;

    my $a = new CGI;

    set_pre_element_string  $a->start_font({-face=>"helvetica"});
    set_post_element_string $a->end_font;

    for $i (25, 85, 300, 6000, 7654, 10000, 7654321) {
        printf "\%7d seconds: \%s\n", $i, beek_date($i);
    }

=head1 Exported Functions

=head2 set_pre_element_string

        The single argument hereto is the text to put before
        each duration element.

=head2 set_post_element_string

        The single argument hereto is the text to put after
        each duration element.

=head2 beek_date

        The first argument is either a number of seconds or
        a duration string in HH:MM:SS format.  It returns
        the date in lima who-list fasion.  It's called
        beek date because, AFAIK, it was written by beek.

=head1 Authors

=head2 The best way to reach us

<telnet://bakhara.org:4000>

=head2 Lord Dorn the God of White Majik 

<dorn@bakhara.org>  Authored the module
the documentation, and did minor re-writes
to get the functions to module-like state.

=head2 Lord Nichus the God of Black Majik 

<nichus@bakhara.org>
Wrote all the actual code used to 
generate the date strings.


=head1 See Also

perl(1).

=cut
