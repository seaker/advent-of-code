#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my %conns is SetHash;
my %degrees;
for $f.IO.lines.map(*.comb(/<[a..z]>+/).Array) -> ($c1, $c2) {
    %conns.set([$c1~$c2, $c2~$c1]);
    ++%degrees{$c1};
    ++%degrees{$c2};
}
my @computers = %degrees.keys;

my %t3s is SetHash;
for @computers.grep(*.starts-with('t')) -> $t {
    for @computers.grep({ %conns{$t~$_} }).combinations(2) -> @a {
        %t3s.set([~] [$t, |@a].sort) if %conns{[~] @a}
    }
}
put 'part 1: ', +%t3s;

my $max-degree = %degrees.values.max;
my $max-size = 2;
my $max-party;
for @computers.grep({ %degrees{$_} == $max-degree }) -> $t {
    for @computers.grep({ %conns{$t~$_} }).combinations($max-size..$max-degree) -> @a {
        if +@a > $max-size && @a.combinations(2).map({ %conns{.[0]~.[1]} }).all {
            $max-size = +@a;
            $max-party = [$t, |@a].sort.join(',');
        }
    }
}
put 'part 2: ', $max-party;
