#!/bin/env raku

multi MAIN('test') {
    use Test;

    is solve(1, 't1.txt'), 10, 'example 1, part 1: 10';
    is solve(2, 't1.txt'), 36, 'example 1, part 2: 36';

    is solve(1, 't2.txt'),  19, 'example 2, part 1:  19';
    is solve(2, 't2.txt'), 103, 'example 2, part 2: 103';

    is solve(1, 't3.txt'),  226, 'example 3, part 1:  226';
    is solve(2, 't3.txt'), 3509, 'example 3, part 2: 3509';

    is solve(1),  3463, 'input.txt, part 1:  3463';
    is solve(2), 91533, 'input.txt, part 1: 91533';

    done-testing;
}

sub satisfy-p2(Array:D $r --> Bool:D) {
    my $t = $r.grep(/^<[a..z]>+$/);
    $t.elems - $t.unique.elems ≤ 1
}

sub solve(UInt:D $part, Str:D $f = 'input.txt' --> UInt:D) {
    my Hash $paths .= new;
    $f.IO.lines.map({ my ($a, $b) = $_.comb(/<[A..Za..z]>+/); $paths{$a}{$b}++; $paths{$b}{$a}++; });
    $paths<end>:delete;
    $paths.keys.map({ $paths{$_}<start>:delete } );

    my $routes .= push(['start']);
    my $cnt = 0;

    loop {
        my Array $new-routes .= new;
        for |$routes -> $r {
            if $r[*-1] eq 'end' {
                ++$cnt;
                next;
            }

            for |$paths{$r[*-1]}.keys -> $n {
                if ($part == 1 and ($n !~~ /^<[a..z]>+$/ || $n !(elem) $r)) ||
                   ($part == 2 and satisfy-p2([|$r, $n])) {
                    $new-routes.push([|$r, $n]);
                }
            }
        }
        $routes = $new-routes.clone;
        last if $routes.elems == 0;
    }

    $cnt
}

multi MAIN(UInt:D $part, Str:D $f where *.IO.e = 'input.txt') {
    put "part $part: ", solve($part, $f);
}
