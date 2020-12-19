#!/bin/env raku

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    $f.IO.slurp.split(/\n\n/)[0].lines.map({
        if $_.match(/^ (\d+) ':' \s+ (\d+)+ %% ' ' '|' \s+ (\d+)+ %% ' ' $/) {
            put "\tregex rx" ~ $0 ~ ' { ' ~
                $1.map({ "<rx{ $_ }>" }).join(' ') ~ ' | ' ~
                $2.map({ "<rx{ $_ }>" }).join(' ') ~ ' }';
        } elsif $_.match(/^ (\d+) ':' \s+ (\d+)+ %% ' ' $/) {
            put "\tregex rx" ~ $0 ~ ' { ' ~
                $1.map({ "<rx{ $_ }>" }).join(' ') ~ ' }';
        } elsif $_.match(/^ (\d+) ':' \s+ '"' (\w) '"' $/) {
            put "\ttoken rx{ $0 } \{ '$1' \}";
        }
    });
}
