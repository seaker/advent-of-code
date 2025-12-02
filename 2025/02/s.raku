#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

put "part {.key+1}: {.value}" for ([«+»] $f.IO.comb(/\d+/)».Int.rotor(2)».minmax.flat.map({[
    /^ (.+) $0  $/ ?? $_ !! 0,
    /^ (.+) $0+ $/ ?? $_ !! 0,
]})).pairs;
