#!/bin/env raku

unit sub MAIN(Str $f_?);

my $f = $f_ // 'input.txt';
my @m = $f.IO.lines.map({ .comb.Array });
my \cols = +@m[0];

my ($sum-p1, $sum-p2) X= 0;
for @m[*;*].unique -> $c {
    print "$c\r";
    my @a = @m[*;*].grep($c, :k).map({ $_ % cols + ($_ div cols)i });
    my @blocks;
    while @a {
        my $i = +@blocks;
        @blocks.push([@a.shift],);
        assemble-blocks(@a, @blocks[$i], @blocks[$i].head);
    }

    my $i = 0;
    for @blocks -> @b {
        my @edges = @b.map({ |exposed-sides($_, @b) }); 
        $sum-p1 += +@b * +@edges;

        my @sides;
        while @edges {
            my $i = +@sides;
            @sides.push([@edges.shift],);
            assemble-sides(@edges, @sides[$i], @sides[$i].head);
        }
        $sum-p2 += +@b * +@sides;
    }
}

put 'part 1: ', $sum-p1;
put 'part 2: ', $sum-p2;

sub exposed-sides(\grid, @a) {
[   ([grid+1+i, grid+1]   if !@a.grep(grid+1)),
    ([grid,     grid+i]   if !@a.grep(grid-1)),
    ([grid+i,   grid+1+i] if !@a.grep(grid+i)),
    ([grid+1,   grid]     if !@a.grep(grid - i)),
]
}

sub side-by-side(\e1, \e2 --> Bool:D) {
    so (e1[1] == e2[0] || e1[0] == e2[1]) && (e1[1]-e1[0]) * (e2[1]-e2[0]) == 1|-1
}

sub assemble-sides(@a, @side, \from) {
    my Bool $found = True;
    while +@a && $found {
        $found = False;
        my @new-found;
        for (@a.grep({ side-by-side($_, from) }, :k) // []).sort(-*) -> \ndx {
            @new-found.push(@a[ndx]);
            @side.push(@a[ndx]);
            @a.splice(ndx, 1);
            $found = True;
        }
        assemble-sides(@a, @side, $_) for @new-found;
    }
}

sub assemble-blocks(@a, @block, \from) {
    my Bool $found = True;
    while +@a && $found {
        $found = False;
        for 1,-1,i,-i -> $delta {
            my @new-found;
            for (@a.grep(from + $delta, :k) // []).sort(-*) -> \ndx {
                @new-found.push(@a[ndx]);
                @block.push(@a[ndx]);
                @a.splice(ndx, 1);
                $found = True;
            }
            assemble-blocks(@a, @block, $_) for @new-found;
        }
    }
}
