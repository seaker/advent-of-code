#!/bin/env raku

my @a = 'input.txt'.IO.slurp.split(/\n\n/);
put 'part 1: ', @a».comb(/<[a..z]>/)».unique».elems.sum;
put 'part 2: ', @a».&{ [(&)] $_.comb(/\S+/)».comb».Set }».elems.sum;
