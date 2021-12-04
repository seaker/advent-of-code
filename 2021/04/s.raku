#!/bin/env raku

sub board-wins(Array:D $board, SetHash:D $drawn --> Bool:D) {
    so (^5).map({ $drawn{$board[$_;^5]}.all }).any ||
       (^5).map({ $drawn{$board[^5;$_]}.all }).any
}

sub board-score(Array:D $board, SetHash:D $drawn --> UInt:D) {
    (^5 X ^5)
        .grep({ !$drawn{$board[.[0];.[1]]} })
        .map({ $board[.[0];.[1]] })
        .sum
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @lines = $f.IO.lines;
    my @boards;
    loop (my $i = 2, my $bid = 0; $i < @lines.elems; $i += 6, ++$bid) {
        @boards[$bid][$_] = @lines[$i + $_].words».UInt.Array for ^5;
    }

    my SetHash $drawn .= new;
    my SetHash $winning-boards .= new;

    for @lines[0].split(',')».UInt -> $i {
        $drawn.set($i);
        for ^@boards.elems -> $bid {
            my $board = @boards[$bid];
            if !$winning-boards{$bid} and board-wins($board, $drawn) {
                $winning-boards.set($bid);
                if $winning-boards.elems == 1 {
                    put 'part 1: ', $i * board-score($board, $drawn);
                } elsif $winning-boards.elems == @boards.elems {
                    put 'part 2: ', $i * board-score($board, $drawn);
                }
            }
        }
    }
}
