#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my (\s1, \s2) = $f.IO.slurp.split("\n\n");
my @towels = s1.comb(/<[bgruw]>+/);

my %mem = '' => 1;
my @cnts = [«+»] s2.words.map(-> $d { (.sign, $_) with possible($d) });
put "part {$_+1}: {@cnts[$_]}" for ^2;

sub possible(Str:D $s --> UInt:D) {
    without %mem{$s} {
        %mem{$s} = [+] @towels.map(-> $t { possible($s.substr($t.chars)) if $s.starts-with($t) });
    }
    %mem{$s}
}
