#!/usr/bin/perl
use Modern::Perl;
no warnings 'experimental::smartmatch';

my @prog;
my $acc = 0;
my $proptr = 0;
my $mode = 0;
my $bail = 1;

# initialization
my $file = shift;

if (!$file) {
    print "Program Absent\n";
    exit(1);
}

@prog = reduce($file);

while ($bail) {
    # termination condition
    if ($proptr >= @prog) { 
        $bail--;
        next;
    }
    
    my $char = $prog[$proptr];
    
    for ($char) {
        when ('a') { $acc++; }
        when ('b') { $acc--; }
        when ('c') { output(); }
        when ('d') { $acc = -$acc; }
        when ('r') { $acc = int(rand($acc + 1)); }
        when ('n') { $acc = 0; }
        when ('$') { $mode = 1 - $mode; }
        when ('l') { $proptr = -1; }
        when (';') { output(1); }
    }
    
    $proptr++;
}

#==================SUBROUTINES==========================

##\
 # Prints ASCII or Numerical value of accumulator
 #/
sub output {
    my ($a) = @_;
    
    if ($a) {
        printf("%s:%s\n", $acc, chr $acc);
    } elsif ($mode) {
        print chr $acc;
    } else {
        print $acc;
    }
}

##\
 # Collects all program instructions into array
 #
 # param: $file: name of input file
 #
 # return: @out: array of program instructions
 #/
sub reduce {
    my ($file) = @_;
    my @out;
    
    open(FILE, '<', $file) or die("Can't open $file: $!\n");
    while (<FILE>) { push(@out, convert($_)); }
    close(FILE);
    
    return @out;
}

##\
 # Converts Instruction String into array
 #
 # param: $file: string containing program Instructions
 #
 # return: $out: array of program instructions
 #/
sub convert {
    my ($file) = @_;
    my @out;
    
    for (0 .. length($file) - 1) {
        my $char = substr($file, 0, 1);
        $file = substr($file, 1);
            
        if ($char =~ m/[abcdrn\$l;]/) { push(@out, $char); }
    }
    
    return @out;
}