#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

sub stir(\op, *@nums) {
    given op {
        when '+' { [+] @nums }
        when '*' { [*] @nums }
    }
}

sub grouping(@a) {
    my @b = [],;
    @a.map({ $_ == 0 ?? @b.push([],) !! @b[*-1].push($_) });
    @b
}

my @Q = $f.IO.lines».words;
my @ops = |@Q.pop;
put 'part 1: ', (^+@Q[0]).map({ stir(@ops[$_], @Q[*;$_]) }).sum;

my @Q2 = $f.IO.lines.head(*-1)».comb;
put 'part 2: ', (@ops Z grouping((^+@Q2[0]).map({ @Q2[*;$_].join.Int }))).map({ stir(.[0], @(.[1])) }).sum;
