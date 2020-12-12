#!/bin/env raku

my @a = 'input.txt'.IO.lines».&{ (TR/FBLR/0101/).parse-base(2) };
put 'part 1: ', @a.max;
put 'part 2: ', @a.minmax (-) @a;
