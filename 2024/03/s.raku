#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my $rgx = / 'mul(' (\d+) ',' (\d+) ')' || "don't()" || 'do()' /;
my Bool $enabled = True;
my ($sum-p1, $sum-p2) X= 0;
for $f.IO.lines».match($rgx, :g).flat {
    when 'do()'    { $enabled = True; }
    when "don't()" { $enabled = False; }
    default {
        with .[0] * .[1] -> \prod {
            $sum-p1 += prod;
            $sum-p2 += prod if $enabled;
        }
    }
}

put 'part 1: ', $sum-p1;
put 'part 2: ', $sum-p2;
