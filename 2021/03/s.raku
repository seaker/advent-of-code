#!/bin/env raku

multi MAIN('1', Str:D $f where *.IO.e = 'input.txt') {
    my $n = $f.IO.words».comb;
    my $width = $n[0].elems;
    my $size  = $n.elems;

    my UInt $g = ([~] (^$width).map({ $n[*;$^i].sum * 2 > $size ?? 1 !! 0 })).parse-base(2);

    put 'part 1: ', $g * (2**$width - 1 - $g);
}

sub most-bit(Array:D $n, UInt:D $pos --> UInt:D) {
    $n[*;$pos].sum * 2 ≥ $n.elems ?? 1 !! 0
}

sub least-bit(Array:D $n, UInt:D $pos --> UInt:D) {
    $n[*;$pos].sum * 2 ≥ $n.elems ?? 0 !! 1
}

multi MAIN('2', Str:D $f where *.IO.e = 'input.txt') {
    my Array $n = $f.IO.words».comb.Array;
    my $width = $n[0].elems;

    my $n-o2 = $n;
    my $n-co2 = $n;
    my Str ($o2, $co2);

    for ^$width -> $i {
        if $n-o2.elems > 1 {
            my $most-bit = most-bit($n-o2, $i);
            $n-o2 = $n-o2.grep({ $_[$i] == $most-bit }).Array;
            $o2 ~= $most-bit;
        } elsif $n-o2.elems == 1 {
            $o2 = $n-o2[0].join;
        }

        if $n-co2.elems > 1 {
            my $least-bit = least-bit($n-co2, $i);
            $n-co2 = $n-co2.grep({ $_[$i] == $least-bit }).Array;
            $co2 ~= $least-bit;
        } elsif $n-co2.elems == 1 {
            $co2 = $n-co2[0].join;
        }
    }

    put 'part 2: ', $o2.parse-base(2) * $co2.parse-base(2);
}
