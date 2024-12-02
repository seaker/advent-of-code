#!/bin/env raku

unit sub MAIN(Str $f_?);

my $f = $f_ // 'input.txt';
my ($cnt-p1, $cnt-p2) = 0, 0;
for $f.IO.lines».words -> @a {
    ++$cnt-p1 if @a.&safe;
    ++$cnt-p2 if @a.&safe || @a.combinations(+@a-1).map(*.&safe).any;
}
put 'part 1: ', $cnt-p1;
put 'part 2: ', $cnt-p2;

my method safe(*@a : --> Bool:D) {
    so -3 ≤ $_ < 0 || 0 < $_ ≤ 3 with all(@a.head(*-1) Z- @a.tail(*-1))
}
