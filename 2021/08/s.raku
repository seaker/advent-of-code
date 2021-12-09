#!/bin/env raku

sub solve(Array:D $in --> Hash:D) {
    my (%cnts_all, %cnts_478);
    $in.map(-> $w { $w.comb».&{ %cnts_all{$_}++ } });
    $in.grep(*.chars == 3|4|7).map(-> $w { $w.comb».&{ %cnts_478{$_}++ } });

    my %res;

    for %cnts_all.kv -> $key, $value {
        %res{$key} = do given $value {
            when 4 { 'e' }
            when 6 { 'b' }
            when 7 { given %cnts_478{$key} {
                when 1 { 'g' }
                when 2 { 'd' }
            } }
            when 8 { given %cnts_478{$key} {
                when 2 { 'a' }
                when 3 { 'c' }
            } }
            when 9 { 'f' }
        }
    }

    %res
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my $data .= push([[.[0].words], [.[1].words]]) for $f.IO.lines».split('|');
    put 'part 1: ', $data.map({ .[1].grep(*.chars == 2|3|4|7).elems }).sum;

    my %digits = abcefg => 0, cf     => 1, acdeg => 2, acdfg   => 3, bcdf   => 4,
                 abdfg  => 5, abdefg => 6, acf   => 7, abcdefg => 8, abcdfg => 9;
    put 'part 2: ', $data.map(-> $d { $d[1].map({ %digits{ .trans(solve($d[0])).comb.sort.join } }).join }).sum;
}
