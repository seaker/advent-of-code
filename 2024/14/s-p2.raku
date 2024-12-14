#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my (\rows, \cols) = do given $f {
    when 't01.txt'   { 7,   11  }
    when 'input.txt' { 103, 101 }
}

my @r = $f.IO.lines.map({ .comb(/'-'? \d+/)».Int.Array });
my \robot-cnt = +@r;

my $round = 0;
loop {
    print "$round\r";

    if +@r.unique(:with({ $^a[0] == $^b[0] && $^a[1] == $^b[1] })) == robot-cnt {
        my @pic = ('.' xx cols).Array xx rows; 
        @pic[.[1];.[0]] = '#' for @r;
        .join.put for @pic;
        put 'part 2: ', $round;

        last;
    }

    my @r_ = @r.map({ [(.[0]+.[2]) % cols, (.[1]+.[3]) % rows, .[2], .[3]] });
    @r = @r_;

    ++$round;
}
