#!/bin/env raku

sub find-it(Array:D $a, UInt:D $prem --> UInt) {
    for 0 ..^ $a.elems-$prem -> $i {
        last unless any($a[$i .. $i+$prem-1].combinations(2).map({.[0]+.[1]})) == $a[$i+$prem];

        LAST { return $a[$i+$prem] }
    }
}

sub find-weakness(Array:D $a, UInt:D $n --> UInt) {
    for 0 ..^ $a.elems-1 -> $i {
        my UInt $sum = $a[$i];

        for $i+1 ..^ $a.elems -> $j {
            $sum += $a[$j];
            return $a[$i..$j].min + $a[$i..$j].max if $sum == $n;
            last if $sum > $n;
        }
    }
}

multi MAIN(Str:D $f where *.IO.e, UInt:D $preamble = 25) {
    my Array $a = $f.IO.lines».UInt.Array;

    my $n = find-it($a, $preamble);
    put 'part 1: ', $n;
    put 'part 2: ', find-weakness($a, $n);
}
