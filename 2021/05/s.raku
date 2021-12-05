#!/bin/env raku

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my $segments = $f.IO.lines».&{ [ .comb(/\d+/)».UInt ] };
    my UInt %h;

    for @$segments -> $seg {
        if $seg[0] == $seg[2] {
            %h{ "$seg[0];$_" }++ for $seg[1]...$seg[3];
        } elsif $seg[1] == $seg[3] {
            %h{ "$_;$seg[1]" }++ for $seg[0]...$seg[2];
        }
    }
    put 'part 1: ', %h.values.grep(*>1).elems;

    for @$segments -> $seg {
        if $seg[0] != $seg[2] and $seg[1] != $seg[3] {
            my Rat $a = ($seg[3] - $seg[1]) / ($seg[2] - $seg[0]);
            my Rat $b = $seg[1] - $a * $seg[0];
            for $seg[0]...$seg[2] -> $x {
                my $y = $a * $x + $b;
                %h{ "$x;$y" }++ if $y == $y.Int;
            }
        }
    }
    put 'part 2: ', %h.values.grep(*>1).elems;
}
