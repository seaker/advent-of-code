#!/bin/env raku

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @cumbers .= push([.comb]) for $f.IO.lines;
    my (\rows, \cols) = @cumbers.elems, @cumbers[0].elems;

    my $round = 0;
    loop {
        my Bool $moved = False;
        (^rows X ^cols)
            .grep({ @cumbers[.[0];.[1]] eq '>' and @cumbers[.[0];(.[1]+1) mod cols] eq '.' })
            .eager
            .map({ @cumbers[.[0]; .[1], (.[1]+1) mod cols] = ('.', '>'); $moved = True; });
        (^rows X ^cols)
            .grep({ @cumbers[.[0];.[1]] eq 'v' and @cumbers[(.[0]+1) mod rows;.[1]] eq '.' })
            .eager
            .map({ @cumbers[.[0], (.[0]+1) mod rows; .[1]] = <. v>; $moved = True; });

        ++$round;
        last unless $moved;
    }
    put 'part 1: ', $round;
}
