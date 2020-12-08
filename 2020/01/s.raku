#!/bin/env raku

# puzzle: https://adventofcode.com/2020/day/1

put 'part 1: ', 'input.txt'.IO.words.combinations(2).grep({ .[0] + .[1] == 2020 }).flat.reduce(* * *);
put 'part 2: ', 'input.txt'.IO.words.combinations(3).grep({ .[0] + .[1] + .[2] == 2020 }).flat.reduce(* * *);
