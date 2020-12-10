#!/bin/env raku

sub is-valid-combo(*@N --> Bool) {
    ? (((0 ..^ @N.elems-1).map({ @N[$_+1] - @N[$_] })).all ≤ 3);
}

sub count-combos(*@N --> UInt) {
    @N.combinations(2..@N.elems)
        .grep(*.[0] == @N[0])
        .grep(*.[*-1] == @N[*-1])
        .grep(&is-valid-combo)
        .elems;
}

sub find-sequence(*@N --> Seq) {
    (0..@N.elems-2 X 1..@N.elems-1)
        .grep({ .[1] - .[0] > 1})
        .grep({ .[1] - .[0] == @N[.[1]] - @N[.[0]] })
        .grep({ .[0] == 0            or @N[.[0]]   - @N[.[0]-1] > 1 })
        .grep({ .[1] == @N.elems - 1 or @N[.[1]+1] - @N[.[1]]   > 1 })
        .map({ .[1] - .[0] + 1 });
}

sub MAIN(Str:D $f where *.IO.e) {
    my @a = $f.IO.lines».UInt.sort;
    @a.unshift(0).push(@a[*-1] + 3);

    my %h;
    ++%h{@a[$_+1] - @a[$_]} for 0 ..^ @a.elems-1;
    put 'part 1: ', %h{1} * %h{3};

    put 'part 2: ', [*] (find-sequence(@a)».&{ count-combos(1..$_) });
}
