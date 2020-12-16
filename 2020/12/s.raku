#!/bin/env raku

grammar Action {
    token TOP    { <move> <number> }
    token move   { <[NSEWLRF]> }
    token number { \d+ }
}

sub move-p1(Int:D $x is rw, Int:D $y is rw, UInt:D $degree is rw, Hash:D $action) {
    given $action<move> {
        when 'N' { $y += $action<number> }
        when 'S' { $y -= $action<number> }
        when 'E' { $x += $action<number> }
        when 'W' { $x -= $action<number> }
        when 'L' { $degree += $action<number>; $degree %= 360 }
        when 'R' { $degree -= $action<number>; $degree %= 360 }
        when 'F' {
            given $degree {
                when   0 { $x += $action<number> }
                when  90 { $y += $action<number> }
                when 180 { $x -= $action<number> }
                when 270 { $y -= $action<number> }
            }
        }
    }
}

sub move-p2(Int:D $x is rw, Int:D $y is rw, Int:D $wx is rw, Int:D $wy is rw, Hash:D $action) {
    given $action<move> {
        when 'N' { $wy += $action<number> }
        when 'S' { $wy -= $action<number> }
        when 'E' { $wx += $action<number> }
        when 'W' { $wx -= $action<number> }
        when 'L' { ($wx, $wy) = ((i, -1, -i)[$action<number> / 90 - 1] * ($wx + $wy * i)).reals».Int }
        when 'R' { ($wx, $wy) = ((-i, -1, i)[$action<number> / 90 - 1] * ($wx + $wy * i)).reals».Int }
        when 'F' {
            $x += $action<number> * $wx;
            $y += $action<number> * $wy;
        }
    }
}

sub MAIN(Str:D $f where *.IO.e) {
    my @actions = $f.IO.lines».&{ my $m = Action.parse($_); { move => ~$m<move>, number => ~$m<number> } };
    my Int ($x, $y, $degree, $wx, $wy);

    ($x, $y, $degree) = (0, 0, 0);
    move-p1($x, $y, $degree, $_) for @actions;
    put 'part 1: ', abs($x) + abs($y);

    ($x, $y, $wx, $wy) = (0, 0, 10, 1);
    move-p2($x, $y, $wx, $wy, $_) for @actions;
    put 'part 2: ', abs($x) + abs($y);
}
