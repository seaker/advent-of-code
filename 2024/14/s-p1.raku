#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my (\rows, \cols) = do given $f {
    when 't01.txt'   { 7,   11  }
    when 'input.txt' { 103, 101 }
}
my (\middle-row, \middle-col) = rows div 2, cols div 2;

my @cnts = 0 xx 4;
for $f.IO.lines {
    my (\col, \row, \vc, \vr) = .comb(/'-'? \d+/);
    given (row + 100*vr) % rows, (col + 100*vc) % cols -> (\r, \c) {
        when 0 ≤ r < middle-row {
            when 0 ≤ c < middle-col    { ++@cnts[0]; }
            when middle-col < c < cols { ++@cnts[1]; }
        }
        when middle-row < r < rows {
            when 0 ≤ c < middle-col    { ++@cnts[2]; }
            when middle-col < c < cols { ++@cnts[3]; }
        }
    }
}
put 'part 1: ', [*] @cnts;
