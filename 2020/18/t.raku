#!/bin/env raku

use MONKEY-SEE-NO-EVAL;

sub infix:<加>(Int:D $m, Int:D $n --> Int:D) is equiv(&infix:<*>)   { $m + $n }
sub infix:<减>(Int:D $m, Int:D $n --> Int:D) is equiv(&infix:<*>)   { $m - $n }
sub infix:<乘>(Int:D $m, Int:D $n --> Int:D) is looser(&infix:<加>) { $m * $n }
sub infix:<除>(Int:D $m, Int:D $n --> Int:D) is looser(&infix:<加>) { $m div $n }

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @a = $f.IO.lines.map(*.trans(<+ -> Z=> <加 减>));
    put 'part 1: ', [+] (EVAL $_ for @a);
    put 'part 2: ', [+] (EVAL $_ for @a.map(*.trans(<* /> Z=> <乘 除>)));
}
