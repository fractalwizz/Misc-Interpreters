#!/usr/bin/perl
use Modern::Perl;
use Getopt::Std;
use File::Basename;
no warnings 'experimental::smartmatch';

my %opt = ();
getopts('f', \%opt);
my @tape;
my $memptr = 0;

my $file = shift;

if (!$file) {
    my $prog = basename($0);
    
    print "USAGE\n";
    print "  $prog [option] textfile\n\n";
    print "DESCRIPTION\n";
    print "  Chance Interpreter written in Perl\n\n";
    print "OPTIONS\n";
    print "  -f  Guaranteed Execution\n\n";
    print "OPERANDS\n";
    print "  textfile  path to input program file\n\n";
    print "EXAMPLES\n";
    print "  $prog helloworld.ch\n";
    print "  $prog -f cat.ch\n";
    
    exit(1);
}

open(FILE, '<', $file) or die("Can't open $file: $!\n");
for my $char (split(//, <FILE>)) {
    for ($char) {
        when(/[>\/ö]/) { movetape(); }
        when(/[\+\\ä]/) { addsub(); }
        when(/[!%\{]/) { output(); }
        when(/[i@^]/) { input(); }
    }
}
close(FILE);

#==================SUBROUTINES==========================

#----------------------------
#--------Instructions--------
#----------------------------

sub r { return int(rand(pop)); }

sub movetape {
    if ($opt{f} || !r(3)) {
        if (r(2)) {
            $memptr++;
        } else {
            $memptr-- if ($memptr > 0);
        }
    }
}

sub addsub {
    if ($opt{f} || !r(3)) {
        if (r(2)) {
            $tape[$memptr]++;
        } else {
            $tape[$memptr]--;
        }
    }
}

sub output {
    if ($opt{f} || !r(3)) { print chr $tape[$memptr]; }
}

sub input {
    if ($opt{f} || !r(3)) {
        print "? ";
        my $val = <>;
        
        $tape[$memptr] = ord $val;
    }
}