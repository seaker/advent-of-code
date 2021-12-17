#!/bin/env raku

my (UInt $tx0, Int $ty0, UInt $tx1, Int $ty1);

sub shoot(UInt:D $xv is copy, Int:D $yv is copy --> Real:D) {
    my ($x, $y) X= 0;
    my Real $besty = -∞;

    loop {
        return $besty if $tx0 ≤ $x ≤ $tx1 and $ty0 ≤ $y ≤ $ty1;
        return -∞ if $x > $tx1;
        return -∞ if $y < $ty0;

        $x += $xv;
        $y += $yv--;

        if $xv > 0 {
            --$xv;
        } elsif $xv < 0 {
            ++$xv;
        }

        $besty = $y if $y > $besty;
    }
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    ($tx0, $tx1, $ty0, $ty1) = $f.IO.slurp.comb(/'-'?\d+/)».Int;
    put 'part 1: ', (1..$tx1 X 1..(-$ty0-1)).map({ shoot(.[0], .[1]) }).max;
    put 'part 2: ', (1..$tx1 X $ty0..(-$ty0-1)).grep({ shoot(.[0], .[1]) > -∞ }).elems;
}
