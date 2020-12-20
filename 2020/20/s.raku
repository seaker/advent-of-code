#!/bin/env raku

my @mat = (^1024).map(*.fmt('%010b').flip.parse-base(2));

sub parse-edge(Str:D $s where *.chars == 10) {
    $s.trans(<. #> Z=> <0 1>).parse-base(2);
}

sub parse-tile(Str:D $s --> Pair) {
    my @lines = $s.lines;
    my UInt $tid = @lines[0].comb(/\d+/).first.UInt;
    #@lines[1..*].map(*.trans(<. #> Z=> <0 1>).parse-base(2)).put;

    $tid =>  [
        parse-edge(@lines[1]), parse-edge(@lines[10]),
        parse-edge(@lines[1..*].map(*.substr(0,1)).join),
        parse-edge(@lines[1..*].map(*.substr(*-1)).join)
    ];
}

multi MAIN('test') {
    use Test;

    done-testing;
}

multi MAIN('try') {
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my %tiles = $f.IO.slurp.split("\n\n", :skip-empty)».&parse-tile;
    my @edges .= push(|$_) for %tiles.values;
    #put @edges.map({ @mat[$_] }).join(', ');
    my BagHash $edge-counts .= new(|@edges, |@edges.map({ @mat[$_] }));
    #put $edge-counts.raku;
    #put ' - ' x 50;
    #put $edge-counts.elems;
    #put ' - ' x 50;
    #put $edge-counts.grep({ .value == 2 }).elems;
    #put ' - ' x 50;
    my Set $single-edges .= new($edge-counts.grep({ .value == 1 }).map({ .key }));
    my %single-counts;
    for %tiles.keys -> $k {
        if any(|%tiles{$k}) ∈ $single-edges and !(one(|%tiles{$k}) ∈ $single-edges) {
            ++%single-counts{$k};
            #put $k;
        }
    }
    #put ' - ' x 50;
    #put %single-counts.raku;
    put 'part 1: ', [*] %single-counts.keys;


    #put @mat.join(" ");
}
