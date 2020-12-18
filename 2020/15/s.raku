#!/bin/env raku

sub solve(Array:D $a, UInt:D $m) {
    state $b = $a;
    return $b[$m] if $m ≤ $b.elems;
    my UInt $i = $b.elems;
    while ($i < $m) {
        my UInt $j = $b.elems - 2;
        my UInt $n = $b[*-1];
        while $j > 0 and $b[$j] != $n {
            --$j;
        }
        $b.push($b[$j] == $n ?? $b.elems-$j-1 !! 0);

        ++$i;
    }

    $b[$m-1];
}

sub solve-new(Array:D $a, UInt:D $m) {
    my $b = $a;
    my UInt @r;
    (^$b.elems).map({ @r[$b[$_]] = $_ });
    return $b[$m-1] if $m ≤ $b.elems;

    $b.push(0);
    my UInt $n = 0;

    for $b.elems ..^ $m -> $i {
        if @r[$n].defined {
            $b.push($b.elems - @r[$n] - 1);
            @r[$n] = $b.elems - 2;
            $n = $b[*-1];
        } else {
            $b.push(0);
            @r[$n] = $b.elems - 2;
            $n = 0;
        }
        put "$i\r" if $i %% 500000;
    }

    $b[$m-1];
}

multi MAIN('test') {
    use Test;
    plan 17;

    is solve(my Array $a = [0, 3, 6], 4), 0, '4th number of [0,3,6] is 0';
    is solve($a = [0, 3, 6], 5), 3, '5th number of [0,3,6] is 3';
    is solve($a = [0, 3, 6], 2020), 436, '2020th number of [0,3,6] is 436';

    is solve-new($a = [0, 3, 6], 4), 0, '4th number of [0,3,6] is 0';
    is solve-new($a = [0, 3, 6], 5), 3, '5th number of [0,3,6] is 3';
    is solve-new($a = [0, 3, 6], 6), 3, '6th number of [0,3,6] is 3';
    is solve-new($a = [0, 3, 6], 7), 1, '7th number of [0,3,6] is 1';
    is solve-new($a = [0, 3, 6], 8), 0, '8th number of [0,3,6] is 0';
    is solve-new($a = [0, 3, 6], 9), 4, '9th number of [0,3,6] is 4';
    is solve-new($a = [0, 3, 6], 10), 0, '10th number of [0,3,6] is 0';
    is solve-new($a = [0, 3, 6], 2020), 436, '2020th number of [0,3,6] is 436';

    is solve-new($a = [1, 3, 2], 2020), 1,    '2020th number of [1,3,2] is 1';
    is solve-new($a = [2, 1, 3], 2020), 10,   '2020th number of [2,1,3] is 10';
    is solve-new($a = [1, 2, 3], 2020), 27,   '2020th number of [1,2,3] is 27';
    is solve-new($a = [2, 3, 1], 2020), 78,   '2020th number of [2,3,1] is 78';
    is solve-new($a = [3, 2, 1], 2020), 438,  '2020th number of [3,2,1] is 438';
    is solve-new($a = [3, 1, 2], 2020), 1836, '2020th number of [3,1,2] is 1836';
}

multi MAIN('try') {
    solve(my Array $a = [0, 3, 6], 2020);
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    put 'part 1: ', solve-new(my Array $a = [9,3,1,0,8,4], 2020);
    put 'part 2: ', solve-new($a = [9,3,1,0,8,4], 30000000);
}
