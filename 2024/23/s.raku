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
        %t3s.set([$t, |@a].sort.join) if %conns{@a.join}
    }
}
put 'part 1: ', +%t3s;

my ($max-size, $max-degree) = 2, %degrees.values.max;
my $max-party;
for @computers -> $t {
    for @computers.grep({ %conns{$t~$_} }).combinations($max-size..$max-degree) -> @a {
        if +@a > $max-size && @a.combinations(2).map({ %conns{.join} }).all {
            $max-size = +@a;
            $max-party = [$t, |@a].sort.join(',');
        }
    }
}
put 'part 2: ', $max-party;
