#!/bin/env raku

grammar Baggy {
    rule TOP { <color> 'bags' 'contain' <luggage>* % ',' '.' }

    token cword   { <[a..z]>+ }
    token color   { <cword> <.ws> <cword> }
    token counts  { \d+ }
    token attrib  { <counts> <.ws> <color> | 'no other' }
    rule  luggage { <attrib> bags? }
}

sub add-rule(Str:D $r, Hash:D $h1 is rw, Hash:D $h2 is rw) {
    my $m = Baggy.parse($r);
    return if ~$m<luggage>[0]<attrib> eq 'no other';

    for ^$m<luggage>.elems -> $i {
        $h1{ ~$m<luggage>[$i]<attrib><color> }.push(~$m<color>);
        $h2{ ~$m<color> }[$i] = { counts => $m<luggage>[$i]<attrib><counts>, color => ~$m<luggage>[$i]<attrib><color> };
    }
}

sub find-all-colors(Str:D $color, Hash:D $h --> Array) {
    my $a;
    for |$h{$color} -> $clr {
        $a.push($clr);
        with $h{$clr} { $a.push(|find-all-colors($clr, $h)) }
    }
    $a;
}

sub count-bags(Str:D $color, Hash:D $h --> UInt) {
    my $cnt;
    for |$h{ $color } -> $b {
        $cnt += $b<counts>;
        with $h{ $b<color> } { $cnt += count-bags($b<color>, $h) * $b<counts> }
    }
    $cnt;
}

my Hash ($h1, $h2) = (Hash.new, Hash.new);
'input.txt'.IO.lines».&{ add-rule($_, $h1, $h2) };
put 'part 1: ', find-all-colors('shiny gold', $h1).unique.elems;
put 'part 2: ', count-bags('shiny gold', $h2);
