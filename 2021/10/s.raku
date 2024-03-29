#!/bin/env raku

my @opening = '([{<'.comb;
my @closing = ')]}>'.comb;
my %rev-map = @closing «=>» @opening;

sub closing(Array:D $d --> Str:D) {
    my @stack;
    for |$d -> $c { given $c {
        when @opening.any { @stack.push($c) }
        when @closing.any { return $c unless @stack.pop eq %rev-map{$c} }
    } }

    @stack.reverse.join
}

sub score-p2(Str:D $s --> UInt:D) {
    state %cscore = @opening Z=> 1..4;
    (0, |$s.comb.map({ %cscore{$_} })).reduce({ $^a * 5 + $^b })
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my $data .= push([$_.comb]) for $f.IO.lines;
    
    my %scores-p1 = @closing Z=> 3, 57, 1197, 25137;
    put 'part 1: ', $data.map({ %scores-p1{closing($_)} // 0 }).sum;

    my @scores-p2 = $data.map({ my $s = closing($_); score-p2($s) if $s.comb[0] ∈ @opening });
    put 'part 2: ', @scores-p2.sort[@scores-p2.elems div 2];
}
