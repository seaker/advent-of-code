#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

multi max-combo(@a, 1) { @a.max }

multi max-combo(@a, \len) {
    my ($ndx, $n) = @a[0..*-len].max(:kv);
    $n ~ max-combo(@a[$ndx+1..*], len-1)
}

put "part {.key+1}: {.value}" for ([«+»] $f.IO.lines».comb.map({
    [max-combo($_,2), max-combo($_,12)]
})).pairs;
