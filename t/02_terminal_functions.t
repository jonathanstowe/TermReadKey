use strict;
use warnings;


use Test::More tests => 1;

use Term::ReadKey;
use Fcntl;

if ( not exists $ENV{COLUMNS} ){
    $ENV{COLUMNS} = 80;
    $ENV{LINES}   = 24;
}

SKIP:
{
    eval {
        if ( $^O =~ /Win32/i ){
            sysopen( IN,  'CONIN$',  O_RDWR ) or die "Unable to open console input:$!";
            sysopen( OUT, 'CONOUT$', O_RDWR ) or die "Unable to open console output:$!";
        }
        else{
            if ( open( IN, "</dev/tty" ) ){
                *OUT = *IN;
                die "Foo" unless -t OUT;
            }
            else{
                die "/dev/tty is absent\n";
            }
        }
    };
    skip( 'Because Term::ReadKey need at least a tty to be useful', 1 ) if $@;
    *IN = *IN;    # Make single-use warning go away
    $|  = 1;
    no strict "subs";
    my $size1 = join( ",", GetTerminalSize( \IN ) );
    my $size2 = join( ",", GetTerminalSize("IN") );
    my $size3 = join( ",", GetTerminalSize(*IN) );
    my $size4 = join( ",", GetTerminalSize( \*IN ) );

    my $size_result=0;
    if ( ( $size1 eq $size2 ) && ( $size2 eq $size3 ) && ( $size3 eq $size4 ) ){
        $size_result=1;
    }
    is($size_result, 1, "Comparing TerminalSize");

}
