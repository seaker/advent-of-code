#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

class Wire { has Bool $.value is rw; }

class Gate {
    has @.in;
    has Str $.op;
    has Str $.out;
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
    }
}

my (%wires, @gates);
with $f.IO.slurp.split("\n\n") -> (\s1, \s2) {
    @gates = s2.lines.map({ Gate.new(:in([.[0], .[2]]), :op(.[1]), :out(.[4])) with .words });
    %wires = @gates.map({ |.in, .out }).flat.unique.map({ $_ => Wire.new });

    s1.lines.map({ %wires{~.[0]}.value = ~.[1] eq '1' with .match(/^ (...) ':' \s+ (<[01]>) $/) });
}
my $m = Machine.new(:%wires, :@gates);
put 'part 1: ', $m.calc;

my @errors;
for @gates.grep(*.out.starts-with('z')) -> $g {
# find all swaps involving z-wires
    next if $g.out eq 'z00'|"z{$m.digits}";

    given $g.op {
        when 'AND' {
            @errors.push($g.out);
            if $g.in.all.starts-with(<x y>.any) {
                # z-wire swapped with CB0
                my $SMB = @gates.first({ .in.sort.join eq $g.in.sort.join && .op eq 'XOR' }).out;
                @errors.push(@gates.first({ .in.any eq $SMB && .op eq 'XOR' }).out);
            } else {
                # z-wire swapped with CB1
                @errors.push(@gates.first({ .in.sort.join eq $g.in.sort.join && .op eq 'XOR' }).out);
            }
        }
        when 'OR' {
            # z-wire swapped with Carry-Out, cannot be swapped with Carry-In because it will short cut input with output.
            @errors.push($g.out);
            my $cb0-gate-in = @gates.first({ .in.all.starts-with(<x y>.any) && .op eq 'AND' && .out eq $g.in.any }).in.sort.join;
            my $SMB = @gates.first({ .in.sort.join eq $cb0-gate-in && .op eq 'XOR' }).out;
            @errors.push(@gates.first({ .in.one eq $SMB && .op eq 'XOR' }).out);
        }
        when 'XOR' {
            if $g.in.all.starts-with(<x y>.any) {
                # z-wire swapped with SMB
                @errors.push($g.out);
                my $CB0 = @gates.first({ .in.sort.join eq $g.sort.join && .op eq 'AND' }).out;
                @errors.push(@gates.first({ .in.one eq $CB0 && .op eq 'OR' }).out);
            }
        }
    }
}

for @gates.grep(*.out.starts-with('z')) -> $g {
# find all swaps excluding z-wires
    next if $g.out eq 'z00'|'z01'|"z{$m.digits}";
    next if $g.out eq @errors.any;
    next if $g.in.any eq @errors.any;

    my $id = $g.out.substr(1);
    # $g.in is composed of SMB and Carry-In
    my $cin-ndx = @gates.first({ .out eq $g.in.any && .op eq 'OR' }, :k);
    my $smb-ndx = @gates.first({ .in.sort.join eq "x{$id}y{$id}" && .op eq 'XOR' }, :k);

    if !$cin-ndx.defined {
        die "did not expect 'CB0 OR CB1 -> Carry-In(one of {$g.in.raku})' is missing";
        #my $SMB = @gates[$smb-ndx].out;        # if Carry-In is swapped with SMB, the fault cannot be found here
        #my $CIN = ($g.in (-) $SMB).keys.first;
        #my $bad-CIN = @gates[$cin-ndx].out;
        #@errors.push($CIN, $bad-CIN);
        #next;
    }

    if @gates[$smb-ndx].out ne $g.in.any {
        # SMB is swapped
        my $CIN = @gates[$cin-ndx].out;         # if Carry-In is swapped with SMB, the fault cannot be found here
        my $SMB = ($g.in (-) $CIN).keys.first;
        my $bad-SMB = @gates[$smb-ndx].out;
        @errors.push($SMB, $bad-SMB);
        next;
    }

    # Now, SMB and Carry-In are both reliable, so does CB1,
    # and CB0 is not swappable with Carry-Out, because it will short cut input with output.
    # It is supposed no more errors will happen here according to the puzzle's descriptions.
}
put 'part 2: ', @errors.sort.join(',');
