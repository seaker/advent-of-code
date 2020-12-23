#!/bin/env raku

class Result {
    has Bool  $.player1-wins;
    has Array $.winning-deck;
}

sub play-game-p1(Array:D $p1-cards, Array:D $p2-cards --> Result) {
    my ($p1, $p2) = $p1-cards, $p2-cards;
    while $p1.elems > 0 and $p2.elems > 0 {
        my ($c1, $c2) = $p1.shift, $p2.shift;
        $c1 > $c2 ?? $p1.push($c1, $c2) !! $p2.push($c2, $c1);
    }

    return Result.new(player1-wins => $p1.elems > 0, winning-deck => $p1.elems > 0 ?? $p1 !! $p2);
}

sub play-game-p2(Array:D $p1-cards, Array:D $p2-cards --> Result) {
    state %mem;
    my $key = $p1-cards.join(':') ~ '-' ~ $p2-cards.join(':');
    with %mem{$key} { return Result.new(player1-wins => %mem{$key}, winning-deck => []) }

    my ($p1, $p2) = ($p1-cards, $p2-cards);
    my $cnt;
    my %local-mem;
    while $p1.elems > 0 and $p2.elems > 0 {
        my $key = $p1.join(':') ~ '-' ~ $p2.join(':');
        with   %mem{$key}       { return Result.new(player1-wins => %mem{$key}, winning-deck => []) }
        orwith %local-mem{$key} { return Result.new(player1-wins => True,       winning-deck => []) }

        my ($c1, $c2) = $p1.shift, $p2.shift;
        my $winner-is-player1 = $c1 ≤ $p1.elems && $c2 ≤ $p2.elems            ??
            play-game-p2($p1[0..^$c1].Array, $p2[0..^$c2].Array).player1-wins !!
            $c1 > $c2;
        $winner-is-player1 ?? $p1.push($c1, $c2) !! $p2.push($c2, $c1);
        %local-mem{$key} = $winner-is-player1;
    }

    %mem{$key} = $p1.elems > 0;
    return Result.new(player1-wins => %mem{$key}, winning-deck => %mem{$key} ?? $p1 !! $p2);
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @all-cards = $f.IO.slurp.split("\n\n");
    my @p1-cards = @all-cards[0].words[2..*]».UInt;
    my @p2-cards = @all-cards[1].words[2..*]».UInt;

    my $deck = play-game-p1(@p1-cards.Array, @p2-cards.Array).winning-deck;
    put 'part 1: ', [+] (^$deck.elems).map({ $deck[$_] * ($deck.elems - $_) });

    $deck = play-game-p2(@p1-cards.Array, @p2-cards.Array).winning-deck;
    put 'part 2: ', [+] (^$deck.elems).map({ $deck[$_] * ($deck.elems - $_) });
}
