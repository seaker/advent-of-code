#!/bin/env raku

grammar Rule {
    rule  TOP     { <rid> ':' <content> }
    token rid     { \d+ }
    rule  content { '"' <char> '"' | <group>+ % '|' }
    token char    { \w }
    rule  group   { <rid>+ % ' ' }
}

class RuleActions {
    method TOP($/)     { make "\tregex { $<rid>.made } \{ { $<content>.made } \}" }
    method rid($/)     { make 'rx' ~ $/.Str }
    method content($/) { with $<char> { make $<char>.made } else { make $<group>.map(*.made).join(' | ') } }
    method char($/)    { make "'{ $/.Str }'" }
    method group($/)   { make $<rid>.map('<' ~ *.made ~ '>').join(' ') }
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    $f.IO.slurp.split(/\n\n/)[0].lines.map({ put Rule.parse($_, :actions(RuleActions)).made });
}
