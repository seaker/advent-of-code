#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

class Wire { has Bool $.value is rw; }

class Gate {
    has @.in;
    has Str $.op;
    has Str $.out is rw;
}

class Machine {
    has %.wires;
    has @.gates;

    has UInt $.digits;
    has @!x-wires;
    has @!y-wires;
    has @!z-wires;

    submethod TWEAK {
        @!x-wires = %!wires.keys.grep(*.starts-with('x')).sort({ $^b cmp $^a });
        @!y-wires = %!wires.keys.grep(*.starts-with('y')).sort({ $^b cmp $^a });
        @!z-wires = %!wires.keys.grep(*.starts-with('z')).sort({ $^b cmp $^a });
        $!digits = +@!x-wires;
    }

    method activate(Gate:D $g) {
        given $g.op {
            when 'AND' { %!wires{$g.out}.value =    [&&] %!wires{$g.in}».value; }
            when 'OR'  { %!wires{$g.out}.value =    [||] %!wires{$g.in}».value; }
            when 'XOR' { %!wires{$g.out}.value = so [^^] %!wires{$g.in}».value; }
        }
    }

    method calc(--> UInt:D) {
        while @!gates.grep({ ! %!wires{.out}.value.defined }).any {
            &.activate($_) for @!gates.grep({ ! %!wires{.out}.value.defined and %!wires{.in}.map({ .value.defined }).all });
        }

        %!wires{@!z-wires}.map({ .value.Int }).join.parse-base(2)
    }

    method add-slow(UInt:D $x, UInt:D $y --> UInt:D) {
        %!wires.keys.map({ %!wires{$_}.value = Bool });    # reset machine

        %!wires{@!x-wires}».value Z= $x.fmt("\%0{$!digits}b").comb.map({ $_ eq '1' });
        %!wires{@!y-wires}».value Z= $y.fmt("\%0{$!digits}b").comb.map({ $_ eq '1' });

        &.calc
    }

    method add-fast(UInt:D $x, UInt:D $y --> UInt:D) {
        %!wires.keys.map({ %!wires{$_}.value = Bool });    # reset machine

        %!wires{@!x-wires}».value Z= $x.fmt("\%0{$!digits}b").comb.map({ $_ eq '1' });
        %!wires{@!y-wires}».value Z= $y.fmt("\%0{$!digits}b").comb.map({ $_ eq '1' });

        @!gates.map({ &.activate($_) });

        %!wires{@!z-wires}.map({ .value.Int }).join.parse-base(2)
    }
}

my (%wires, @gates);
my @input = $f.IO.slurp.split("\n\n");
my Bool $non-stop = +@input == 3;

@gates = @input[1].lines.map({ Gate.new(:in([.[0], .[2]]), :op(.[1]), :out(.[4])) with .words });
%wires = @gates.map({ |.in, .out }).flat.unique.map({ $_ => Wire.new });

@input[0].lines.map({ %wires{~.[0]}.value = ~.[1] eq '1' with .match(/^ (...) ':' \s+ (<[01]>) $/) });

put 'part 1: ', .calc with Machine.new(:%wires, :@gates);

put qq:to/Grumbling/;

    part 2 begins ...

    It is actually a lovely add-only calculator but broken.
    Let's do some simple math with it ...
    Grumbling

my $digits;
with Machine.new(:%wires, :@gates) -> $m {
    $digits = $m.digits;
    my ($x, $y) = 1, 1;
    for 1..$digits -> $i {
        my $r = $m.add-slow($x, $y);
        if $r != $x + $y {
            print qq:to/Serious-Analysis/;
              $x + $y = $r ?!
                which should be {$x+$y},
                there must be wires swapped near z{$i.fmt('%02d')} ...
            Serious-Analysis
        }
        $x *= 2;
        $y *= 2;
    }
}

put qq:to/Whisper/;

    hmm, it helps, but still does not solve the problem.
    I need to know the exact names of the wires went wrong,
    and with which they are swapped ...

    Tried https://www.devtoolsdaily.com/graphviz/
      does not help either ...
    Whisper

pause;
put qq:to/Chart/;
    After close imvestigation, the following circuit diagram can be drawn:

       Xdd -------+      +-----+                               +-----+
                  +------| XOR |------ Sum-Bit --------+------ | XOR | ------ Zdd
                  |      +-----+                       |       +-----+
                  |                    Carry-In -------+       +-----+
                  |      +-----+                       +------ | AND | ------ Carry-Bit-1
                  +------| AND |------ Carry-Bit-0             +-----+             |
                  |      +-----+            |                                      |
       Ydd -------+                         |                                  +------+
                                            +--------------------------------- |  OR  | ------ Carry-Out
                                                                               +------+


    This exact partial pattern repeats throughout the entire diagram, execpt for z00 and z45.
      Xdd and Ydd are global input, Carry-In is internal input.
      Zdd is global output, Carry-out is internal output.
      Other bits stay within the partial diagram.

    Let's tag the sum-bit as SMB, the carry bits as CB0, CB1 and Carry.
    Chart

put "Now, Let's start sorting some wires ...";
pause;
my @gates_;
put "1st gate: 'x00 XOR y00 -> z00'";
with @gates.first({ .in.sort.join eq 'x00y00' && .op eq 'XOR' && .out eq 'z00' }, :k) -> $i {
    @gates_.push(|@gates.splice($i, 1));
} else {
    die 'did not expect "x00 XOR y00 -> z00" is missing';
}

my Str $Carry;
my UInt $carry-ndx;
put "2nd gate: 'x00 AND y00 -> Carry'";
with @gates.first({ .in.sort.join eq 'x00y00' && .op eq 'AND' }, :k) -> $i {
    $Carry = @gates[$i].out;
    put "  Carry is $Carry";
    $carry-ndx = $i;
    @gates_.push(@gates[$i]);
} else {
    die "did not expect 'x00 AND y00 -> Carry' is missing";
}

my @errors;
my $ordinal = 2;
for 1..^$digits -> $dgt {
    my $id = $dgt.fmt('%02d');
    my @swap;

    my $g = @gates.first(*.out eq "z{$id}");
    given $g.op {
        when 'AND' {
            @swap.push($g.out);
            if $g.in.all.starts-with(<x y>.any) {
                # z-wire swapped with CB0
                my $SMB = @gates.first({ .in.sort.join eq $g.in.sort.join && .op eq 'XOR' }).out;
                @swap.push(@gates.first({ .in.any eq $SMB && .op eq 'XOR' }).out);
            } else {
                # z-wire swapped with CB1
                @swap.push(@gates.first({ .in.sort.join eq $g.in.sort.join && .op eq 'XOR' }).out);
            }
        }
        when 'OR' {
            # z-wire swapped with Carry-Out, cannot be swapped with Carry-In because it will short cut input with output.
            @swap.push($g.out);
            my $cb0-gate-in = @gates.first({ .in.all.starts-with(<x y>.any) && .op eq 'AND' && .out eq $g.in.any }).in.sort.join;
            my $SMB = @gates.first({ .in.sort.join eq $cb0-gate-in && .op eq 'XOR' }).out;
            @swap.push(@gates.first({ .in.one eq $SMB && .op eq 'XOR' }).out);
        }
        when 'XOR' {
            if $g.in.all.starts-with(<x y>.any) {
                # z-wire swapped with SMB
                @swap.push($g.out);
                my $CB0 = @gates.first({ .in.sort.join eq $g.sort.join && .op eq 'AND' }).out;
                @swap.push(@gates.first({ .in.one eq $CB0 && .op eq 'OR' }).out);
            }
        }
    }

    if +@swap    == 0           &&
       $g.out    ne 'z01'       &&
       $g.out    ne @errors.any &&
       $g.in.any ne @errors.any
    {   # $g.in is composed of SMB and Carry-In
        my $cin-ndx = @gates.first({ .out eq $g.in.any && .op eq 'OR' }, :k);
        my $smb-ndx = @gates.first({ .in.sort.join eq "x{$id}y{$id}" && .op eq 'XOR' }, :k);

        if !$cin-ndx.defined {
            die "did not expect 'CB0 OR CB1 -> Carry-In(one of {$g.in.raku})' is missing";
        } elsif @gates[$smb-ndx].out ne $g.in.any {
            # SMB is swapped
            my $CIN = @gates[$cin-ndx].out;         # if Carry-In is swapped with SMB, the fault cannot be found here
            my $SMB = ($g.in (-) $CIN).keys.first;
            my $bad-SMB = @gates[$smb-ndx].out;
            @swap.push($SMB, $bad-SMB);
        }
    }

    if +@swap {
        (@gates.first({ .out eq @swap[1] }).out, @gates.first({ .out eq @swap[0] }).out) = @swap;
        put "{@swap[0]} swapped with {@swap[1]}";
        put "  fixed ...";
        pause;
        @errors.push(|@swap); 
    }

    # populate @gates_
    @gates.splice($carry-ndx, 1);       # delayed delete

    my ($x-wire, $y-wire, $z-wire) = <x y z> X~ $id;
    put "{ordinal(++$ordinal)} gate: '$x-wire XOR $y-wire -> SMB'";
    my $i = @gates.first({ .in.sort.join eq "x{$id}y{$id}" && .op eq 'XOR' }, :k);
    my $SMB = @gates[$i].out;
    put "  SMB is $SMB";
    @gates_.push(|@gates.splice($i, 1));

    put "{ordinal(++$ordinal)} gate: '$x-wire AND $y-wire -> CB0'";
    $i = @gates.first({ .in.sort.join eq "x{$id}y{$id}" && .op eq 'AND' }, :k);
    my $CB0 = @gates[$i].out;
    put "  CB0 is $CB0";
    @gates_.push(|@gates.splice($i, 1));

    put "{ordinal(++$ordinal)} gate: 'Carry($Carry) AND SMB($SMB) -> CB1'";
    $i = @gates.first({ .in.sort.join eq [$Carry, $SMB].sort.join && .op eq 'AND' }, :k);
    my $CB1 = @gates[$i].out;
    put "  CB1 is $CB1";
    @gates_.push(|@gates.splice($i, 1));

    put "{ordinal(++$ordinal)} gate: 'Carry($Carry) XOR SMB($SMB) -> $z-wire'";
    $i = @gates.first({ .in.sort.join eq [$Carry, $SMB].sort.join && .op eq 'XOR' }, :k);
    @gates_.push(|@gates.splice($i, 1));

    put "{ordinal(++$ordinal)} gate: 'CB0($CB0) OR CB1($CB1) -> Carry'";
    $i = @gates.first({ .in.sort.join eq [$CB0, $CB1].sort.join && .op eq 'OR' }, :k);
    $Carry = @gates[$i].out;
    put "  Carry is $Carry";
    $carry-ndx = $i;
    @gates_.push(@gates[$i]);
}
@gates.splice($carry-ndx, 1);

@gates = @gates_;
my $m = Machine.new(:%wires, :@gates);
pause "Now, the machine is repaired. Let's do some serious tests ...";

use Test;

my ($x, $y) = 1, 1;
for 1..$digits -> $i {
    is $m.add-fast($x, $y), $x+$y, "$x + $y = {$x+$y}";
    $x *= 2;
    $y *= 2;
}

pause 'some more tests ...';
for ^20 {
    ($x, $y) = 2⁴⁵.rand.Int, 2⁴⁵.rand.Int;
    is $m.add-fast($x, $y), $x+$y, "$x + $y = {$x+$y}";
}

done-testing;

pause 'I am about to print the answer for part 2, press return to confirm: ';
put "\npart 2: ", @errors.sort.join(',');

print qq:to/Thanx/;
    
    Merry Xmas and Happy New Year!
    Thanx, Eric, for everything!
    Thanx

sub ordinal(UInt:D $num) {
    given $num {
        when $num % 100 == 11|12|13 { $num ~ 'th' }
        when $num % 10 == 1         { $num ~ 'st' }
        when $num % 10 == 2         { $num ~ 'nd' }
        when $num % 10 == 3         { $num ~ 'rd' }
        default                     { $num ~ 'th' }
    }
}

sub pause($msg = 'Press return to continue: ') {
    prompt $msg unless $non-stop;
}
