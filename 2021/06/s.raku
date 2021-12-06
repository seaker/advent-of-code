#!/bin/env raku

my @latterns;

multi lattern(0)                     { 1 }
multi lattern(UInt:D $n where 1≤*≤7) { 2 }
multi lattern(8)                     { 3 }
multi lattern(UInt:D $n) {
	return @latterns[$n] if @latterns[$n].defined;

	@latterns[$n] = lattern($n-7) + lattern($n-9);
	@latterns[$n]
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    put 'part 1: ', $f.IO.slurp.split(',')».&{ lattern( 80 - $_) }.sum;
    put 'part 2: ', $f.IO.slurp.split(',')».&{ lattern(256 - $_) }.sum;
}
