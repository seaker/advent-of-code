#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my ($L, $R) = (.[*;0], .[*;1]).map(*.sort.Array) with $f.IO.lines».words;

put 'part 1: ', ($L «-« $R)».abs.sum;
put 'part 2: ', $L.map({ $_ * $R.Bag{$_} }).sum;
