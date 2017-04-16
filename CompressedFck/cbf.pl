#!/usr/bin/perl
use Modern::Perl;
use Getopt::Std;
use File::Basename;
no warnings 'experimental::smartmatch';

our %trans = (
               '+' => '000', '-' => '001',
               '<' => '010', '>' => '011',
               '.' => '100', ',' => '101',
               '[' => '110', ']' => '111',
             );
my @base = split(//, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");
my %opt = ();

getopts('b', \%opt);

my $file = shift;

if (!$file) {
    my $prog = basename($0);
    
    print "USAGE\n";
    print "  $prog [options] textfile\n\n";
    print "DESCRIPTION\n";
    print "  CompressedFck Translator written in Perl\n\n";
    print "OPTIONS\n";
    print "  -b        Base 64 support for encoding / decoding";
    print "OPERANDS\n";
    print "  textfile  path to input text file\n\n";
    print "FILES\n";
    print "  Output files written to current directory\n";
    print "EXAMPLES\n";
    print "  $prog ./Examples/cat.bf\n";
    print "  $prog -b triangle.cbf\n";
    
    exit(1);
}
13903
if ($file =~ m/\S+\.bf$/i) {
    encode($file);
} elsif ($file =~ m/\S+\.cbf/i) {
    decode($file);
} else {
    print "Error: Unsupported File\n";
    exit(1);
}

#==================SUBROUTINES==========================

##\
 # Translates Brainfck code into the CompressedFck format
 # Average compression of 60%
 #
 # param: $file: Input program file
 #/
sub encode {
    my ($file) = @_;
    my $prog;
    my @tmp;
    
    open(FILE, '<', $file) or die("Can't open $file: $!\n");
    while(<FILE>) { $prog .= filter($_); }
    close(FILE);
    
    while (modul(length($prog), (8 / 3)) != 0) {
        $prog .= '+';
    }
    
    $prog =~ s/(.)/$trans{$1}/g;
    
    $file =~ /(\S+)\./;
    $file = $1 . ".cbf";
    
    open(COM, '>', $file) or die("Can't create $file: $!\n");
    
    if ($opt{b}) { # Encode to Base 64
        @tmp = $prog =~ /(.{6})/g;
        
        for my $six (@tmp) {
            $six = $base[oct("0b" . $six)];
        }
        
        for (@tmp) { print COM $_; }
    } else {
        @tmp = $prog =~ /(.{8})/g;
        print COM pack('b8' x @tmp, @tmp);
    }
    
    close(COM);
}

##\
 # Translates CompressedFck formatted text into valid BrainFck code
 #
 # param: $file: Input text file
 #/
sub decode {
    my ($file) = @_;
    my $prog;
    
    open(FILE, '<', $file) or die("Can't Open $file: $!\n");
    while(<FILE>) { $prog .= $_; }
    close(FILE);
    
    if ($opt{b}) {
        my $pmet;
        for my $char (split(//, $prog)) {
            $pmet .= sprintf("%06b", findex($char)); # http://www.perlmonks.org/?node_id=49491
        }
        $prog = $pmet;
    } else {
        $prog = unpack('b*', $prog);
    }
    
    my @hold = $prog =~ /(.{3})/g;
    $prog = "";
    
    for (@hold) {
        for my $key(keys %trans) {
            if ($trans{$key} == $_) { $prog .= $key; last; }
        }
    }
    
    $file =~ /(\S+)\./;
    $file = $1 . ".bf";
    
    open(COM, '>', $file) or die("Can't create $file: $!\n");
    print COM $prog;
    close(COM);
}

##\
 # Filters Instruction String
 #
 # param: $str: String containing program instructions
 #
 # return: $out: String of filtered program instructions
 #/
sub filter {
    my ($str) = @_;
    my $out = "";
    
    for (0 .. length($str) - 1) {
        my $char = substr($str, 0, 1);
        $str = substr($str, 1);
            
        if ($char =~ m/[\>\<\+\-\.\,\[\]]/) { $out .= $char; }
    }
    
    return $out;
}

# http://www.perlmonks.org/?node_id=470365
sub modul {
    my ($a, $b) = @_;
    return $a - int($a / $b) * $b;
}

##\
 # Utility to find index of array for single char
 #
 # param: $ch: char to search for
 #
 # return: $out: index in base
 #/
sub findex {
    my ($ch) = @_;
    my $out = 0;
    
    for (@base) {
        last if ($_ ~~ $ch);
        $out++;
    }
    
    return $out;
}