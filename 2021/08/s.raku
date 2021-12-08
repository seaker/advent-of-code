#!/bin/env raku

sub solve(Array:D $in --> Hash:D) {
    my Hash $res .= new;

    my %cnts-all;
    for @$in -> $w {
        %cnts-all{$_}++ for $w.comb;
    }

    my SetHash $cand7 .= new;
    my SetHash $cand8 .= new;
    for %cnts-all.kv -> $key, $value {
        given $value {
            when 4 { $res{$key} = 'e' }
            when 6 { $res{$key} = 'b' }
            when 7 { $cand7.set($key) }
            when 8 { $cand8.set($key) }
            when 9 { $res{$key} = 'f' }
        }
    }

    my %cnts478;
    for @$in.grep(*.chars == 3|4|7) -> $w {
        %cnts478{$_}++ for $w.comb;
    }
    for %cnts478.kv -> $key, $value {
        given $value {
            when 1 { $res{$key} = 'g' if $cand7{$key}; }
            when 2 { $res{$key} = 'a' if $cand8{$key};
                     $res{$key} = 'd' if $cand7{$key};
                   }
            when 3 { $res{$key} = 'c' if $cand8{$key}; }
        }
    }

    %$res
}

multi MAIN('try') {
    solve(<be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb>.Array);
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my Array $data .= new;
    for $f.IO.lines».split('|') -> ($i, $o) {
        $data.push([[$i.words], [$o.words]]);
    }

    put 'part 1: ', $data.map({ .[1].grep(*.chars == 2|3|4|7).elems }).sum;

    my %digits =
        abcefg => 0, cf     => 1, acdeg => 2, acdfg   => 3, bcdf   => 4,
        abdfg  => 5, abdefg => 6, acf   => 7, abcdefg => 8, abcdfg => 9;

    put 'part 2: ',
        (^$data.elems)
            .map(-> $i {
                $data[$i;1].map({ %digits{ .trans(solve($data[$i;0])).comb.sort.join } }).join
            })
            .sum;
}
