#!/bin/env raku

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my ($x, $aim, $y) X= 0;

    for $f.IO.lines».words -> ($action, $dist) {
        given $action {
            when 'up'      { $aim -= $dist; }
            when 'down'    { $aim += $dist; }
            when 'forward' { $x   += $dist; $y += $aim * $dist; }
        }
    }

    put 'part 1: ', $x * $aim;
    put 'part 2: ', $x * $y;
}
