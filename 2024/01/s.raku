#!/bin/env raku

unit sub MAIN(Str $f_?);

my $f = $f_ // 'input.txt';
my @a = $f.IO.words».Int;
my @L = @a[0, *+2 ... +@a - 2].sort;
my @R = @a[1, *+2 ... +@a - 1].sort;

put 'part 1: ', (@L «-« @R)».abs.sum;
put 'part 2: ', @L.map({ $_ * @R.Bag{$_} }).sum;
