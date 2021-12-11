#!/bin/env raku

sub inc(Array:D $o, Int:D \row, Int:D \col) {
    $o[row;col]++ if 0 ≤ row ≤ 9 && 0 ≤ col ≤ 9 && $o[row;col] != 0;
}

sub flash(Array:D $o, UInt:D \row, UInt:D \col) {
    $o[row;col] = 0;
    ([-1,-1], [-1,0], [-1,1],
     [ 0,-1],         [ 0,1],
     [ 1,-1], [ 1,0], [ 1,1]
    ).map({ inc($o, row + .[0], col + .[1]) });
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my $o .= push([.comb».UInt]) for $f.IO.lines;

    my ($round, $cnt) = (1, 0);
    loop {
        (^10 X ^10).map({ ++$o[.[0];.[1]] });
        my $cnt1 = 0;

        loop {        
            my $cnt0 = 0;
            for ^10 X ^10 -> (\row, \col) { 
                if $o[row;col] > 9 {
                    flash($o, row, col);
                    ++$cnt0;
                }
            }
            $cnt1 += $cnt0;
            last unless $cnt0 > 0;
        }
        $cnt += $cnt1;
        put 'part 1: ', $cnt if $round == 100;

        last if $cnt1 == 100;
        ++$round;
    }
    put 'part 2: ', $round;
}
