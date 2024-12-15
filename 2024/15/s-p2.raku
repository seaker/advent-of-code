#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

use MONKEY-TYPING;
augment class Str {
    method xtrans {
        given self {
            when 'O' { '[]' }
            when '.' { '..' }
            when '#' { '##' }
            when '@' { '@.' }
        }
    }
}

my (\s1, \s2) = $f.IO.slurp.split("\n\n");

my @m = s1.lines.map({ .comb».xtrans.join.comb.Array });
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
            my @m_ = @m.reverse.Array;
            my @a = walk-wide(@m_, rows-1-$row, $col, 1).unique(:with({ $^a[0] == $^b[0] && $^a[1] == $^b[1] }));
            if @a {
                (@m_[.[0]+1;.[1]], @m_[.[0];.[1]]) = (@m_[.[0];.[1]], @m_[.[0]+1;.[1]]) for @a;
                @m = @m_.reverse.Array;
                --$row;
            }
        }
        when 'v' {
            my @a = walk-wide(@m, $row, $col, 1).unique(:with({ $^a[0] == $^b[0] && $^a[1] == $^b[1] }));
            if @a {
                (@m[.[0]+1;.[1]], @m[.[0];.[1]]) = (@m[.[0];.[1]], @m[.[0]+1;.[1]]) for @a;
                ++$row if @a;
            }
        }
    }
}

@m[$row;$col] = '@';
.join.put for @m;
put 'part 2: ', @m[*;*].grep('[', :k).map({ $_ % cols + ($_ div cols) * 100 }).sum;

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

# default direction is down 'v'
sub walk-wide(@m, \row, \col, \width --> Array:D) {
    return [] if row ≥ rows-2;

    given @m[row+1;col..col+width-1] -> @n {
        when @n.all eq '.' { [[row,col],([row,col+1] if width == 2)] }
        when @n.any eq '#' { [] }
        default {   # there is warehouse under
            given width {
                when 1 {
                    my @a = walk-wide(@m,row+1,col-1+(@n[0] eq '['),2);
                    return [] if +@a == 0;
                    [|@a, [row,col]]
                }
                when 2 {
                    given @n[0] {
                        when '[' {
                            my @a = walk-wide(@m,row+1,col,2);
                            return [] if +@a == 0;
                            [|@a, [row,col], [row,col+1]]
                        }
                        when ']' {
                             my @a = walk-wide(@m,row+1,col-1,2);
                             return [] if +@a == 0;

                             my @b;
                             if @n[1] eq '[' {
                                 @b = walk-wide(@m,row+1,col+1,2);
                                 return [] if +@b == 0;
                                 return [|@a, |@b, [row,col], [row,col+1]];
                             }
                             [|@a, [row,col], [row,col+1]]
                        }
                        default  {  # '.['
                            my @a = walk-wide(@m,row+1,col+1,2);
                            return [] if +@a == 0;
                            [|@a, [row,col], [row,col+1]]
                        }
                    }
                }
            }
        }
    }
}
