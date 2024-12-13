#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

my ($sum-p1, $sum-p2) X= 0;
for $f.IO.slurp.split("\n\n") -> $m {
    my ($a, $b, $p) = $m.lines».comb(/\d+/);
    $sum-p1 += solve($a, $b, $p);
    $sum-p2 += solve($a, $b, $p »+» 10_0000_0000_0000);
}
put 'part 1: ', $sum-p1;
put 'part 2: ', $sum-p2;

sub solve(\a, \b, \p) {
    my \ap = (b[0]*p[1] - b[1]*p[0]) div (b[0]*a[1] - b[1]*a[0]);
    my \bp = (a[0]*p[1] - a[1]*p[0]) div (a[0]*b[1] - a[1]*b[0]);

    ap ≥ 0 && bp ≥ 0 && ap*a[0] + bp*b[0] == p[0] ?? 3*ap + bp !! 0
}
