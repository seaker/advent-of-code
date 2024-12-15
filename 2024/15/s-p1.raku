#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my (\s1, \s2) = $f.IO.slurp.split("\n\n");

my @m = s1.lines.map({ .comb.Array });
my (\rows, \cols) = +@m, +@m[0];

my ($row, $col) = ($_ div cols, $_ % cols with @m[*;*].first('@', :k));
@m[$row;$col] = '.';

for s2.lines.join.comb -> $d {
    given $d {
        when '<' {
            $col = cols-1-$col;
            walk(@m[$row;cols-1...0], $col, cols);
            $col = cols-1-$col;
        }
        when '>' {
            walk(@m[$row], $col, cols);
        }
        when '^' {
            $row = rows-1-$row;
            walk(@m[rows-1...0;$col], $row, rows);
            $row = rows-1-$row;
        }
        when 'v' {
            walk(@m[^rows;$col], $row, rows);
        }
    }
}

@m[$row;$col] = '@';
.join.put for @m;
put 'part 1: ', @m[*;*].grep('O', :k).map({ $_ % cols + ($_ div cols) * 100 }).sum;

# default direction is right '>'
sub walk(@r, $col is rw, \cols) {
    return if $col ≥ cols-2;

    with @r[$col+1..cols-1].first(<# .>.any, :k) -> \pos {
        if @r[$col+1+pos] eq '.' {
            ++$col;
            @r[$_] = @r[$_-1] for $col+pos...$col;
        }
    }
}
