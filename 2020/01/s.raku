#!/bin/env raku

# puzzle: https://adventofcode.com/2020/day/1

my @N = 'input.txt'.IO.words».UInt;
put 'part 1: ', @N.combinations(2).grep({ .[0] + .[1] == 2020 }).first.reduce(* * *);

# for simplicity
#put 'part 2: ', @N.combinations(3).grep({ .[0] + .[1] + .[2] == 2020 }).first.reduce(* * *);

# for runtime efficiency
put 'part 2: ', @N.combinations(2).grep({ (2020 - .[0] - .[1]) ∈  @N }).map({ .[0] * .[1] * (2020 - .[0] - .[1]) }).first;
