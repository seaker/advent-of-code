#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

multi max-combo(@a, 1) { @a.max }

multi max-combo(@a, \len) {
    my ($ndx, $n) = @a[0..*-len].max(:kv);
    $n ~ max-combo(@a[$ndx+1..*], len-1)
}

my ($cnt-p1, $cnt-p2) X= 0;
for $f.IO.lines».comb -> @a {
    $cnt-p1 += max-combo(@a,  2);
    $cnt-p2 += max-combo(@a, 12);
}
put 'part 1: ', $cnt-p1;
put 'part 2: ', $cnt-p2;
