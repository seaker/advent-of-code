#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

my @m = $f.IO.lines.map({ .comb.Array });
my (\rows, \cols) = +@m, +@m[0];

my $start-pos = $_ % cols + ($_ div cols)i with @m[*;*].first('^', :k);
my %walked = walk(@m, $start-pos, -i);
put 'part 1: ', +%walked;

my %new-obstacles is SetHash;
for ^rows -> \row {
    print "{row}\r";
    for ^cols -> \col {
        next unless @m[row;col] eq '.';
        next unless %walked{col+row*i}.any;

        @m[row;col] = '#';
        my $pos = col+row*i;
        my $delta = %walked{$pos}[0];
        my %walked_ = walk(@m, $pos-$delta, $delta);
        @m[row;col] = '.';

        %new-obstacles.set($pos) if +%walked_ == 0;
    }
}
put 'part 2: ', +%new-obstacles;

sub out-of-bound($pos, $delta --> Bool:D) {
    ($pos.re == 0      && $delta == -1) ||
    ($pos.re == cols-1 && $delta ==  1) ||
    ($pos.im == 0      && $delta == -i) ||
    ($pos.im == rows-1 && $delta ==  i)
}

sub walk(@m, Complex:D $pos is copy, Complex:D $delta is copy) {
    my %walked_ = ($pos, []).Hash;
    while !out-of-bound($pos, $delta) {
        $pos += $delta;
        if @m[$pos.im;$pos.re] eq '#' {
            $pos -= $delta;
            $delta *= i;
        } else {
            return ().SetHash if %walked_{$pos}.grep($delta);
            %walked_{$pos.Complex}.push($delta);
        }
    }
    %walked_
}
