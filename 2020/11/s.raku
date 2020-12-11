#!/bin/env raku

sub count-it(Array:D $S, Int:D $x, UInt:D $max-x, Int:D $y, UInt:D $max-y --> UInt) {
    return 0 if $x < 0 or $y < 0 or $x ≥ $max-x or $y ≥ $max-y;
    $S[$x;$y] eq '#' ?? 1 !! 0;
}

sub count-around-p1(Array:D $S, Int:D $x, UInt:D $max-x, Int:D $y, UInt:D $max-y --> UInt) {
    [+] (count-it($S, $x+.[0], $max-x, $y+.[1], $max-y)
            for (-1,-1), (-1, 0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1));
}

sub count-in-direction(
    Array:D $S,
    Int:D $x, Int:D $x-move, UInt:D $max-x,
    Int:D $y, Int:D $y-move, UInt:D $max-y
    --> UInt
) {
    my (Int $X, Int $Y) = ($x, $y);
    loop {
        $X += $x-move;
        return 0 if $X < 0 or $X ≥ $max-x;

        $Y += $y-move;
        return 0 if $Y < 0 or $Y ≥ $max-y;

        given $S[$X;$Y] {
            when '#' { return 1 }
            when 'L' { return 0 }
        }
    }
}

sub count-around-p2(Array:D $S, Int:D $x, UInt:D $max-x, Int:D $y, UInt:D $max-y --> UInt) {
    [+] (count-in-direction($S, $x, .[0], $max-x, $y, .[1], $max-y)
            for (-1,-1), (-1, 0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1));
}

sub apply-rule(Array:D $S, Int:D $x, Int:D $y, Sub:D $count-around, UInt:D $thresh-hold --> Str) {
    given $S[$x;$y] {
        when '.' { return '.' }
        when 'L' { return $count-around($S, $x, $S.elems, $y, $S[0].elems) == 0            ?? '#' !! 'L' }
        when '#' { return $count-around($S, $x, $S.elems, $y, $S[0].elems) >= $thresh-hold ?? 'L' !! '#' }
    }
}

sub apply-rule-p1(Array:D $S, Int:D $x, Int:D $y --> Str) { apply-rule($S, $x, $y, &count-around-p1, 4) }
sub apply-rule-p2(Array:D $S, Int:D $x, Int:D $y --> Str) { apply-rule($S, $x, $y, &count-around-p2, 5) }

sub one-round(Array:D $S, Sub:D $apply-rule --> Array) {
    my Array $R .= new;
    (0..$S.elems-1 X 0..$S[0].elems-1).map({ $R[.[0];.[1]] = $apply-rule($S, .[0], .[1]) });
    $R;
}

sub run(Array:D $S, Sub:D $apply-rule --> UInt) {
    my $cnt;

    my $L = $S;
    my $N = one-round($L, $apply-rule);
    print "round { ++$cnt }\r";

    while $N !eqv $L {
        $L = $N;
        $N = one-round($L, $apply-rule);
        print "round { ++$cnt }\r";
    }

    [+] (count-it($L, .[0], $S.elems, .[1], $S[0].elems) for 0..$S.elems-1 X 0..$S[0].elems-1);
}

sub MAIN(Str:D $f where *.IO.e) {
    my Array $S .= push(.comb.Array) for $f.IO.lines;
    put 'part 1: ', run($S, &apply-rule-p1);
    put 'part 2: ', run($S, &apply-rule-p2);
}
