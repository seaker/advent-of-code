#!/bin/env raku

unit sub MAIN(Str $f_?);

my $f = $f_ // 'input.txt';
my (\s1, \s2) = $f.IO.slurp.split("\n\n");

my %rules;
s1.lines.map({ %rules{.[0]}.push(.[1]) with .comb(/\d+/) });

my @sums = [«+»] s2.lines».comb(/\d+/).map(-> @a {
    with @a.sort({ !%rules{$^a}.grep($^b) }) -> @b {
        @a eqv @b ?? ($_, 0) !! (0, $_) with @b[+@b/2]
    }
});
put "part {$_+1}: {@sums[$_]}" for ^2;
