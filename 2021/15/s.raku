#!/bin/env raku

sub dijkstra-d15(Array:D \n, UInt:D \max-row, UInt:D \max-col, Str:D \src, Str \tgt) {
    my (SetHash $Q, %dist) = SetHash.new;

    $Q.set(src);
    my $qcnt = max-row * max-col - 1;
    %dist{src} = 0;

    while $qcnt > 0 {
        my ($u, $min-v) = ('', ∞);
        for $Q.keys -> \k {
            if %dist{k}.defined && %dist{k} < $min-v {
                $min-v = %dist{k};
                $u = k;
            }
        }

        print "$qcnt \r";
        $Q.unset($u);
        --$qcnt;
        last if tgt.defined && tgt eq $u;

        my (\r, \c) = $u.split(';');
        for [-1,0], [0,-1], [0,1], [1,0] -> (\dr, \dc) {
            my (\row, \col) = (r+dr, c+dc);
            next unless 0 ≤ row < max-row && 0 ≤ col < max-col;

            my \v = "{row};{col}";
            $Q.set(v) if !$Q{v} && !%dist{v}.defined;

            my Real \d = %dist{$u} + n[row;col];
            %dist{v} = d if d < (%dist{v} // ∞);
        }
    }

    %dist.Hash
}

sub solve(Array:D \n --> Real:D) {
    my (\max-row, \max-col) = (n.elems, n[0].elems);
    my \target = "{max-row-1};{max-col-1}";
    my $dist = dijkstra-d15(n, max-row, max-col, '0;0', target);

    $dist{target}
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @n .= push([.comb».Real]) for $f.IO.lines;
    put 'part 1: ', solve(@n);

    my (\max-row, \max-col) = (@n.elems, @n[0].elems);
    my @n2;
    (^max-row X ^max-col).map({ @n2[.[0];.[1]] = @n[.[0];.[1]] });
    for ^max-row -> \row {
        for 1..4 -> $i {
            @n2[row].push(|(@n[row].map({ ($_+$i-1) mod 9 + 1 })));
        }
    }
    for 1..4 -> $i {
        for ^max-row -> \row {
            @n2[$i*max-row + row] = @n2[row].map({ ($_+$i-1) mod 9 + 1 });
        }
    }
    put 'part 2: ', solve(@n2);
}
