#!/bin/env raku

sub solve(Array:D \poly, Hash:D \rules, UInt:D \rounds --> UInt:D) {
    my %cnts = poly[0] => 1, poly[*-1] => 1;

    my %ccnts;
    ++%ccnts{ poly[$_] ~ poly[$_+1] } for ^(poly.elems-1);

    for ^rounds {
        my %new-ccnts;
        for rules.kv -> \k,\v {
            my (\a,\b) = k.comb;
            %new-ccnts{a~v} += %ccnts{k} // 0;
            %new-ccnts{v~b} += %ccnts{k} // 0;
        }
        %ccnts = %new-ccnts;
    }
    %ccnts.kv.map(->\k,\v { k.comb».&{ %cnts{$_} += v // 0; } });

    [-] %cnts.values.map({ $_ div 2 }).sort[*-1, 0]
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my (Array \poly, Hash \rules) = $f.IO.slurp.split("\n\n").map(->\p,\r {
        |( [p.comb], %( r.lines.map({ .words[0] => .words[2] }) ) )
    });

    put 'part 1: ', solve(poly, rules, 10);
    put 'part 2: ', solve(poly, rules, 40);
}
