#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

class Pod {
    has UInt $.size is rw;
    has UInt $.id is rw;
}

my $i = 0;
my @pods = gather for $f.IO.words[0].comb».Int -> $n {
    take Pod.new(:size($n), :id($i %% 2 ?? ($i div 2) !! UInt));
    ++$i;
}

my $moved;
my $last-j = +@pods - 1;
repeat {
    $moved = False;
    my $j = $last-j;
    print "$j    \r";
    while $j > 0 && !$moved {
        next without @pods[$j].id;
        with @pods.first({ !.id.defined && .size ≥ @pods[$j].size }, :k) -> $i {
            next if $i > $j;
            @pods[$i].id = @pods[$j].id;
            if @pods[$i].size > @pods[$j].size {
                @pods.splice($i+1, 0, Pod.new(:size(@pods[$i].size - @pods[$j].size)));
                ++$j;
                @pods[$i].size = @pods[$j].size;
            }
            @pods[$j].id = UInt;
            $last-j = $j;
            $moved = True;
        }
        NEXT --$j;
    }
} until !$moved;

my ($sum, $pos) X= 0;
for @pods -> \pod {
    $sum += $pos++ * (pod.id // 0) for ^pod.size;
}
put 'part 2: ', $sum;
