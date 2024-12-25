#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

for $f.IO.split("\n\n") {
    my @m = .lines.map(*.comb.Array);
    state (\rows, \cols) = +@m, +@m[0] unless rows.defined;
    state (@keys, @locks);

    if @m[0].all eq '#' {
        @locks.push([@m[*;$_].first('.', :k) - 1 for ^cols],);
    } else {
        @keys.push([@m[rows-1...0;$_].first('.', :k) - 1 for ^cols],);
    }

    LAST put 'part 1: ', (@keys X @locks).map({ so ([«+»] $_).all < rows-1 }).sum;
}
