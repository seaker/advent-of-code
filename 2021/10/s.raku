#!/bin/env raku

my @opening = |< ( [ { >, '<';
my @closing = |< ) ] } >, '>';
my %mapping = @opening «=>» @closing;
my %rev-map = @closing «=>» @opening;

sub illegal-closing(Array:D $d --> Str:D) {
    my @stack;
    for |$d -> $c { given $c {
        when @opening.any { @stack.push($c) }
        when @closing.any { return $c unless @stack.pop eq %rev-map{$c} }
    } }

    ' '
}

sub score-p2(Str:D $s --> UInt:D) {
    state %cscore = @closing Z=> 1..4;

    my UInt $score = 0;
    $score = $score * 5 + %cscore{$_} for $s.comb;

    $score
}

sub closing(Array:D $d --> Str:D) {
    my @stack;
    for |$d -> $c { given $c {
        when @opening.any { @stack.push($c) }
        when @closing.any { @stack.pop }
    } }

    @stack.join.flip.trans(%mapping)
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my $data .= push([$_.comb]) for $f.IO.lines;
    
    my %scores-p1 = |@closing, ' ' Z=> 3, 57, 1197, 25137, 0;
    put 'part 1: ', $data.map({ %scores-p1{illegal-closing($_)} }).sum;

    my @scores-p2 = $data.grep({ illegal-closing($_) eq ' ' }).map({ score-p2(closing($_)) });
    put 'part 2: ', @scores-p2.sort[@scores-p2.elems div 2];
}
