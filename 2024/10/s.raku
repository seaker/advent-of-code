#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

my @m = $f.IO.lines.map({ .comb.Array });
my (\rows, \cols) = +@m, +@m[0];

my ($sum-p1, $sum-p2) X= 0;
for @m[*;*].grep(0, :k) -> \pos {
    my (\row, \col) = pos div cols, pos % cols;
    my %ends is SetHash;    # for part 1

    @m[row;col] := '.';
    $sum-p2 += find-trail(1, row, col, @m, %ends);
    $sum-p1 += +%ends;
    @m[row;col] := 0;
}
put 'part 1: ', $sum-p1;
put 'part 2: ', $sum-p2;

sub in-bound(Int:D \row, Int:D \col --> Bool:D) {
    0 ≤ row < rows && 0 ≤ col < cols
}

sub find-trail(UInt:D \from, UInt:D \row, UInt:D \col, @m, %ends --> UInt:D) {
    if from > 9 {
        %ends.set(col+row*i);
        return 1;
    }

    my $sum = 0;    # for part 2
    for ([-1,0], [1,0], [0,-1], [0,1]) -> $d {
        my (\row_, \col_) = row + $d[0], col + $d[1];
        next unless in-bound(row_, col_);
        next unless @m[row_;col_] == from;

        @m[row_;col_] := '.';
        $sum += find-trail(from+1, row_, col_, @m, %ends);
        @m[row_;col_] := from;
    }

    $sum
}
