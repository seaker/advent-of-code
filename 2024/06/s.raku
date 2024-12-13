#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my @m = $f.IO.lines.map({ .comb.Array });
my (\rows, \cols) = +@m, +@m[0];

my $start-pos = $_ % cols + ($_ div cols)i with @m[*;*].first('^', :k);
my %walked = walk(@m, $start-pos, -i);
put 'part 1: ', +%walked;

my %new-obstacles is SetHash;
for ^rows -> \row {
    print "{row}\r";
    for ^cols -> \col {
        my $pos = col+row*i;
        next unless @m[row;col] eq '.';
        next unless %walked{$pos}.any;

        @m[row;col] = '#';
        my $delta = %walked{$pos}[0];
        my $len = +walk(@m, $pos-$delta, $delta);
        @m[row;col] = '.';

        %new-obstacles.set($pos) if $len == 0;
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
            %walked_{$pos}.push($delta);
        }
    }
    %walked_
}
