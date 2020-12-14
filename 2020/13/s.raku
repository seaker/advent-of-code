#!/bin/env raku

# Fermat's Little Theorem
#   solve： nx mod m = 1
sub mod-inv(Int:D $n, Int:D $m --> Int) { expmod($n, $m - 2, $m) }

# Chinese Remainder Theorem
sub solve(*%H) {
    my Int $prod = [*] %H.keys;
    my $sum = 0;

    for %H.keys».Int -> Int $k {
        next if %H{$k} == 0;
        my Int $m = ($prod / $k).Int;
        $sum += mod-inv($m, $k) * ($k - %H{$k}) * $m;
    }

    $sum % $prod;
}

multi MAIN('test') {
    use Test;
    plan 7;

    is mod-inv(7, 13), 2, '2 x 7 mod 13 = 1';

    is solve(|{ 7 => 0, 13 => 1 }), 77, 'simple case: 7,13 => 77';
    is solve(|{ 17 => 0, 13 => 2, 19 => 3 }), 3417, '17,x,13,19 => 3417';
    is solve(|{ 67 => 0, 7 => 1, 59 => 2, 61 => 3 }), 754018, '67,7,59,61 => 754018';
    is solve(|{ 67 => 0, 7 => 2, 59 => 3, 61 => 4 }), 779210, '67,x,7,59,61 => 779210';
    is solve(|{ 67 => 0, 7 => 1, 59 => 3, 61 => 4 }), 1261476, '67,7,x,59,61 => 1261476';
    is solve(|{ 1789 => 0, 37 => 1, 47 => 2, 1889 => 3 }), 1202161486, '1789,37,47,1889 => 1202161486';
}

multi MAIN(Str:D $f where *.IO.e) {
    my ($start, $id-line) = $f.IO.lines;

    my %h = $id-line.comb(/\d+/)».Int».&{ $_ => $_ - $start % $_ };
    my $k = %h.keys.min({ %h{$_} });
    put 'part 1: ', $k * %h{$k};

    my @buses = $id-line.comb(/\w+/);
    my %hb = (^@buses.elems).grep({ @buses[$_] !eq 'x' }).map({ @buses[$_] => $_ });
    put 'part 2: ', solve(|%hb);
}
