#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my ($p1, $p2) X= 0;
my $dial = 50;

for $f.IO.words».trans('LR'=>'-+') -> $clicks {
    $p2 += abs(($dial + $clicks - ($clicks < 0)) div 100) - ($dial == 0 && $clicks < 0);

    $dial = ($dial + $clicks) % 100;
    ++$p1 if $dial == 0;
}

put 'part 1: ', $p1;
put 'part 2: ', $p2;
