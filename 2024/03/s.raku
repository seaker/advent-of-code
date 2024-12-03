#!/bin/env raku

unit sub MAIN(Str $f_?);

my $f = $f_ // 'input.txt';

my $rg = / 'mul(' (\d+) ',' (\d+) ')' || "don't()" || 'do()' /;
my Bool $enabled = True;
my ($sum-p1, $sum-p2) X= 0;
for $f.IO.lines -> \line {
    for line.match($rg, :g) -> $m {
        given ~$m {
            when 'do()'    { $enabled = True; }
            when "don't()" { $enabled = False; }
            default {
                with $m[0] * $m[1] -> \prod {
                    $sum-p1 += prod;
                    $sum-p2 += prod if $enabled;
                }
            }
        }
    }
}

put 'part 1: ', $sum-p1;
put 'part 2: ', $sum-p2;
