#!/bin/env raku

# https://adventofcode.com/2020/day/25

my UInt ($pubkey, $loop-size) X= 1;
for (1..20201227) -> $i {
    $pubkey = ($pubkey * 7) mod 20201227;
    if $pubkey == 1965712|19072108 {
        $loop-size = $i;
        last;
    }
    print "$i\r" if $i %% 500_000;
}

put 'part 1: ', expmod(1965712 + 19072108 - $pubkey, $loop-size, 20201227);
