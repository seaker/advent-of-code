#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt', UInt:D $count = 1000);

my %boxes is SetHash = $f.IO.lines;
my %dists = %boxes.keys.combinations(2).map(-> ($a,$b) { "$a;$b" => ($a.split(',') «-» $b.split(',')).map(*²).sum });

my @circuits;
my $cnt = 0;
for %dists.sort(*.value) -> $p {
    my ($a, $b) = $p.key.split(';');
    my @related = @circuits.grep({ ($a,$b).any (elem) $_ }, :k);
    given +@related {
        when 0 { @circuits.push(($a,$b).SetHash); }
        when 1 { @circuits[@related[0]].set([$a,$b]); }
        when 2 {
            my %bigger is SetHash = [(|)] @circuits[@related];
            @circuits.splice($_, 1) for @related.reverse; 
            @circuits.push(%bigger);
        }
    }
    %boxes.unset([$a,$b]);

    put 'part 1: ', [*] @circuits.sort(-*.elems)[^3] if ++$cnt == $count;

    if +@circuits == 1 && +%boxes == 0 {
        put 'part 2: ', $a.match(/^\d+/) * $b.match(/^\d+/);
        last;
    }
}
