#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my (\s1, \s2) = $f.IO.slurp.split("\n\n");

my %rules;
s1.lines.map({ %rules{.[0]}.push(.[1]) with .comb(/\d+/) });

my @sums = [«+»] s2.lines».comb(/\d+/).map(-> @a {      # page list is saved in @a
    with @a.sort({ !%rules{$^a}.grep($^b) }) -> @b {    # @b is sorted page list
        @a eqv @b ?? ($_, 0) !! (0, $_) with @b[+@b/2]  # if @a is in order, add the middle page number to part 1 counter,
    }                                                   # otherwise add it to part 2 counter
});
put "part {$_+1}: {@sums[$_]}" for ^2;
