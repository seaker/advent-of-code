#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

my @m = $f.IO.lines.map({ .comb.Array });
my (\rows, \cols) = +@m, +@m[0];

my ($ap1, $ap2) = SetHash.new, SetHash.new;
for @m[*;*].unique.grep(* ne '.') -> $c {
    for @m[*;*].grep($c, :k).map({ $_ % cols + ($_ div cols)i }).combinations(2) -> (\a,\b) {
        for (b.Complex, b - a), (a.Complex, a - b) -> ($w is copy, $delta) {
            $ap1.set($w+$delta) if in-bound($w+$delta);
            while in-bound($w) {
                $ap2.set($w);
                $w += $delta;
            }
        }
    }
}
put 'part 1: ', +$ap1;
put 'part 2: ', +$ap2;

sub in-bound(Complex:D \loc --> Bool:D) {
    (0 ≤ .re < cols && 0 ≤ .im < rows) with loc
}
