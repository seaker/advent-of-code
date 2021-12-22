#!/bin/env raku

my %diracs;

multi dirac(UInt:D \p1, UInt:D \s1, UInt:D \p2, UInt:D \s2, Bool:D \t1 where ?* --> Array:D) {
    return [0, 1] if s2 ≥ 21;

    my \key = "{p1}-{s1}-{p2}-{s2}-1";
    return %diracs{key} if %diracs{key}.defined;

    %diracs{key} = ((1,3), (3,4), (6,5), (7,6), (6,7), (3,8), (1,9)).map(->(\n,\steps) {
        my \np1 = (p1 + steps - 1) mod 10 + 1;
        n «*« dirac(np1, s1 + np1, p2, s2, False)
    }).reduce(* »+« *);

    %diracs{key}
}

multi dirac(UInt:D \p1, UInt:D \s1, UInt:D \p2, UInt:D \s2, Bool:D \t1 where !* --> Array:D) { 
    return [1, 0] if s1 ≥ 21;

    my \key = "{p1}-{s1}-{p2}-{s2}-0";
    return %diracs{key} if %diracs{key}.defined;

    %diracs{key} = ((1,3), (3,4), (6,5), (7,6), (6,7), (3,8), (1,9)).map(->(\n,\steps) {
        my \np2 = (p2 + steps - 1) mod 10 + 1;
        n «*« dirac(p1, s1, np2, s2 + np2, True)
    }).reduce(* »+« *);

    %diracs{key}
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my (\p1, \p2) = $f.IO.lines.map({ .words[*-1].UInt });
    put 'part 2: ', dirac(p1, 0, p2, 0, True).max;
}
