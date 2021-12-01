#!/bin/env raku

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @n = $f.IO.words;
    put 'part 1: ', [+] @n Z< @n[1..*];
    put 'part 2: ', [+] @n Z< @n[3..*];
}
