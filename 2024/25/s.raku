#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

for $f.IO.split("\n\n") {
    state ($rows, $cols, @keys, @locks);

    with .lines.map(*.comb.Array) -> @m {
        ($rows, $cols) = +@m, +@m[0] unless $rows.defined;

        when @m[0].all eq '#' { @locks.push([@m[*;$_].first('.', :k) - 1 for ^$cols],); }
        default               { @keys.push([@m[$rows-1...0;$_].first('.', :k) - 1 for ^$cols],); }
    }

    LAST put 'part 1: ', (@keys X @locks).map({ so ([«+»] $_).all < $rows-1 }).sum;
}
