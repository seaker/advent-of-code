#!/bin/env raku

sub lattern(UInt:D \n --> UInt:D) {
    state @latterns = 1, |(2 xx 7), 3;
    @latterns[n] = lattern(n-7) + lattern(n-9) unless @latterns[n].defined;
    @latterns[n]
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @n = $f.IO.slurp.split(',');
    put 'part 1: ', @n».&{ lattern( 80 - $_) }.sum;
    put 'part 2: ', @n».&{ lattern(256 - $_) }.sum;
}
