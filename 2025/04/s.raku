#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

sub neighbours(@rolls, \row, \col) {
    +(-1..1 X -1..1).grep({
        (.[0] || .[1]) && (@rolls[row+.[0];col+.[1]] // '.') eq '@'
    })
}

my @rolls = $f.IO.lines».comb».Array;
my (\rows, \cols) = +@rolls, +@rolls[0];

put 'part 1: ', +(^rows X ^cols).grep({ @rolls[.[0];.[1]] eq '@' && neighbours(@rolls, .[0], .[1]) < 4 });

my $cnt-p2 = 0;
loop {
    my $removed = 0;
    for (^rows X ^cols).grep({ @rolls[.[0];.[1]] eq '@' && neighbours(@rolls, .[0], .[1]) < 4 }) -> @pos {
        @rolls[@pos[0];@pos[1]] = '.';
        ++$removed;
    }
    last unless $removed;
    $cnt-p2 += $removed;
}

put 'part 2: ', $cnt-p2;
