#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

my @m = $f.IO.lines.map({ .comb.Array });
my (\rows, \cols) = +@m, +@m[0];

my $cnt-p1 = 0;
++$cnt-p1 if its-xmas-p1(@m[.[0];.[1] .. .[1]+3].join) for ^rows X ^(cols-3);   # horizontal
++$cnt-p1 if its-xmas-p1(@m[.[0] .. .[0]+3;.[1]].join) for ^(rows-3) X ^cols;   # vertical
for ^(rows-3) X ^(cols-3) -> (\row, \col) {
    ++$cnt-p1 if its-xmas-p1([~] (@m[row+$_;col+$_]   for ^4));     # down-right
    ++$cnt-p1 if its-xmas-p1([~] (@m[row+$_;col-$_+3] for ^4));     # down-left
}
put 'part 1: ', $cnt-p1;

my $cnt-p2 = 0;
++$cnt-p2 if its-xmas-p2(|$_) for ^(rows-2) X ^(cols-2);
put 'part 2: ', $cnt-p2;

sub its-xmas-p1($s --> Bool:D) {
    so $s eq 'XMAS'|'SAMX'
}

sub its-xmas-p2(\row, \col --> Bool:D) {
    return False unless @m[row+1;col+1] eq 'A';
    so ('MS'|'SM') eq (@m[row;col] ~ @m[row+2;col+2]) & (@m[row;col+2] ~ @m[row+2;col])
}
