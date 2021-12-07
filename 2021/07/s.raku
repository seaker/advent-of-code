#!/bin/env raku

my method cost-p1(UInt:D \n : UInt:D \k --> UInt:D) {
    abs(n - k)
}

my method cost-p2(UInt:D \n : UInt:D \k --> UInt:D) {
    my UInt $i = abs(n - k);
    $i * ($i + 1) div 2
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @n = $f.IO.slurp.split(',')».UInt;
    put 'part 1: ', @n.minmax».&{ @n».&cost-p1($_).sum }.min;
    put 'part 2: ', @n.minmax».&{ @n».&cost-p2($_).sum }.min;
}
