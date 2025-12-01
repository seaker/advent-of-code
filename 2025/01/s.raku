#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my ($p1, $p2) X= 0;
my $a = 50;

for $f.IO.words».trans('LR'=>'-+') -> $b {
    my $c = ($a + $b) % 100;
    ++$p1 if $c == 0;
    $p2 += abs(($a + $b - ($b < 0)) div 100) - ($a == 0 && $b < 0);

    $a = $c;
}

put 'part 1: ', $p1;
put 'part 2: ', $p2;
