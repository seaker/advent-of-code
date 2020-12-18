#!/bin/env raku

grammar Expression-p1 {
    rule  TOP    { <term>+ % <op> }
    rule  term   { <number> | '(' <TOP> ')' }
    token op     { <[-+*/]> }
    token number { \d+ }
}

class ExpActions-p1 {
    method TOP($/)   {
        my Int $result = $<term>[0].made;
        for (1..$<op>.elems) -> $i {
            given $<op>[$i-1] {
                when '*' { $result *=   $<term>[$i].made }
                when '/' { $result div= $<term>[$i].made }
                when '+' { $result +=   $<term>[$i].made }
                when '-' { $result -=   $<term>[$i].made }
            }
        }
        make $result;
    }

    method term($/)   {
        with $<number> {
            make $<number>.made;
        } else {
            make $<TOP>.made;
        }
    }

    method op($/)     { make $/.Str }
    method number($/) { make $/.Int }
}

grammar Expression-p2 {
    rule  TOP    { <group>+ % <mul-op> }
    rule  group  { <term>+ % <add-op> }
    rule  term   { <number> | '(' <TOP> ')' }
    token mul-op { <[*/]> }
    token add-op { <[+-]> }
    token number { \d+ }
}

class ExpActions-p2 {
    method TOP($/) {
        my Int $result = $<group>[0].made;
        for (1..$<mul-op>.elems) -> $i {
            given $<mul-op>[$i-1] {
                when '*' { $result *=   $<group>[$i].made }
                when '/' { $result div= $<group>[$i].made }
            }
        }
        make $result;
    }

    method group($/) {
        my Int $result = $<term>[0].made;
        for (1..$<add-op>.elems) -> $i {
            given $<add-op>[$i-1] {
                when '+' { $result += $<term>[$i].made }
                when '-' { $result -= $<term>[$i].made }
            }
        }
        make $result;
    }

    method term($/)   {
        with $<number> {
            make $<number>.made;
        } else {
            make $<TOP>.made;
        }
    }

    method mul-op($/) { make $/.Str }
    method add-op($/) { make $/.Str }
    method number($/) { make $/.Int }
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @a = $f.IO.lines;
    put 'part 1: ', [+] (Expression-p1.parse($_, :actions(ExpActions-p1)).made for @a);
    put 'part 2: ', [+] (Expression-p2.parse($_, :actions(ExpActions-p2)).made for @a);
}
