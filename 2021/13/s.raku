#!/bin/env raku

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my ($dots-str, $fold-str) = $f.IO.slurp.split("\n\n");

    my %dots;
    $dots-str.words».comb(/\d+/).map({ %dots{ "{ .[0] };{ .[1] }" } = '#' });

    my $round = 0;
    for $fold-str.lines».&{ .words[2].split('=') } -> ($d, $pos)  {
        my %new-dots;
        for %dots.keys».split(';')».UInt -> ($row, $col) {
            given $d {
                when 'x' { %new-dots{ "{ $row≤$pos ?? $row !! $pos*2-$row };$col" } = '#'; }
                when 'y' { %new-dots{ "$row;{ $col≤$pos ?? $col !! $pos*2-$col }" } = '#'; }
            }
        }
        %dots = %new-dots;
        put 'part 1: ', %dots.elems if $round++ == 0;
    }

    put 'part 2:';
    my @pos = %dots.keys».split(';')».UInt;
    for @pos.map(*[1]).minmax -> $y {
        put [~] (%dots{"$_;$y"} // ' ' for @pos.map(*[0]).minmax);
    }
}
