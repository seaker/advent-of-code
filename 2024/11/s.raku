#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt', UInt $rounds?);

my @a = $f.IO.words».Int;

with $rounds {
    put 'count: ', @a.map({ count($_, $rounds) }).sum;
} else {
    put 'part 1: ',  @a.map({ count($_, 25) }).sum;
    put 'part 2: ',  @a.map({ count($_, 75) }).sum;
}

my %mem;
sub count(UInt:D $n, UInt:D $depth --> UInt:D) {
    return 1 if $depth == 0;

    my $key = "$n,$depth";
    without %mem{$key} {
         %mem{$key} = do given $n {
            when $n == 0       { count(1, $depth-1) }
            when $n.chars %% 2 { count($n.substr(0,$_).Int, $depth-1) + count($n.substr($_).Int, $depth-1) with $n.chars/2 }
            default            { count($n*2024, $depth-1) }
        }
    }
    %mem{$key}
}
