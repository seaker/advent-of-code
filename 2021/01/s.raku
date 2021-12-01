#!/bin/env raku

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @nums = $f.IO.words;
    put 'part 1: ', (1 .. @nums.elems-1).grep({ @nums[$_] > @nums[$_-1] }).elems;
    put 'part 2: ', (3 .. @nums.elems-1).grep({ @nums[$_] > @nums[$_-3] }).elems;
}
