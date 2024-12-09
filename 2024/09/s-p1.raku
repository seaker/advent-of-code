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

$i = 1;
my $j = +@pods div 2 * 2;
while $i < $j {
    while $j > $i && @pods[$j].size > 0 {
        my \sz = min(@pods[$i].size, @pods[$j].size);
        @pods[$i].id = @pods[$j].id;
        @pods[$j].size -= sz;
        if @pods[$i].size > sz {
            @pods.splice($i+1, 0, Pod.new(:size(@pods[$i].size - sz)));
            @pods[$i].size = sz;
            ++$i;
            ++$j;
        } else {
            $i += 2;
        }
    }
    $j -= 2;
}

my ($sum, $pos) X= 0;
for @pods -> \pod {
    last without pod.id;
    $sum += $pos++ * pod.id for ^pod.size;
}
put 'part 1: ', $sum;
