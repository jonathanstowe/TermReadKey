# Term::ReadKey Makefile.PL Version 2.03

use ExtUtils::MakeMaker;
use Carp;

if( $ExtUtils::MakeMaker::Version < 3.5 ) {
        croak("Sorry, but MakeMaker 3.5 or better is needed to build this package.");
}

#$Verbose = 0;
&WriteMakefile(
	NAME => "Term::ReadKey",
	DISTNAME => "TermReadKey",
	VERSION => "2.03",
	PM => { "ReadKey.pm" => '$(INST_LIBDIR)/ReadKey.pm'},

# Uncomment these to allow testing of sgtty under Linux. Not needed normally.
#	INC => "-I/usr/include/bsd",
#	LIBS => "-lbsd"
);

sub MY::realclean {
	$_ = MM->realclean();
	s/\t/\trm -f cchars.h\n\t/;
	$_;
}

sub MY::top_targets {
	$_ = MM->top_targets();
	$_ .= "

sgtty cchars.h: genchars.pl
	\$(PERL) -I\$(PERL_LIB) genchars.pl

distcc: genchars.pl
	\$(PERL) -I\$(PERL_LIB) genchars.pl dist

ReadKey.c: cchars.h

";
	$_;

}

sub MY::test {
	$_ = MM->test();
	s/test.pl/-w test.pl/;
	$_;
}
