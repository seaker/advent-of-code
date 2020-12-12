#!/bin/env raku

sub count-trees(Array:D @M, UInt:D $x, UInt:D $y) {
    ((0, *+$y ...^ { $_ ≥ @M.elems }) Z (0, *+$x ... *)).map({ @M[.[0]][.[1] % @M[0].elems] }).grep('#').elems;
}

sub MAIN(Str:D $f where *.IO.e) {
    my Array @M .= push($_.comb.Array) for $f.IO.lines;
    put 'part 1: ', count-trees(@M, 3, 1);
    put 'part 2: ', [*] ((1,1), (3,1), (5,1), (7,1), (1,2)).map({ count-trees(@M, .[0], .[1]) });
}
