#!/bin/env raku

sub solve(Array:D \poly, Hash:D \rules, UInt:D \rounds) {
    my %ccnts;
    ++%ccnts{ poly[$_] ~ poly[$_+1] } for ^(poly.elems-1);

    for ^rounds -> $i {
        my %new-ccnts;
        for rules.kv -> \k,\v {
            my (\a,\b) = k.comb;
            %new-ccnts{a~v} += %ccnts{k} // 0;
            %new-ccnts{v~b} += %ccnts{k} // 0;
        }
        %ccnts = %new-ccnts;
    }

    my %cnts;
    %ccnts.kv.map(->\k,\v { k.comb».&{ %cnts{$_} += v // 0; } });

    [-] %cnts.values.map({ ($_+1) div 2 }).sort[*-1, 0]
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my Hash $rules .= new;
    my (Array \poly) = $f.IO.slurp.split("\n\n").map(->\p,\r { r.lines.map({ $rules{.words[0]} = .words[2] }); [p.comb] });

    put 'part 1: ', solve(poly, $rules, 10);
    put 'part 2: ', solve(poly, $rules, 40);
}
