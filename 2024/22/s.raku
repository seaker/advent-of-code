#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my %mem;
my $cnt-p1 = 0;
my $i = 0;
for $f.IO.words».Int -> $n is copy {
    print "{++$i}\r";
    my @a = $n % 10;
    my @diff;

    for ^2000 {
        next-pseudo($n);
        @a.push($n % 10);
        @diff.push(@a[*-1] - @a[*-2]);
    }
    $cnt-p1 += $n;

    my %kept is SetHash;
    for ^1997 -> $i {
        my $key = @diff[$i..$i+3].join;
        unless %kept{$key} {
            %kept.set($key);
            %mem{$key} += @a[$i+4];
        }
    }
}
put 'part 1: ', $cnt-p1;
put 'part 2: ', %mem.values.max;

sub next-pseudo(UInt:D $n is rw) {
    $n +^= ($n * 64);
    $n %= 16777216;
    $n +^= ($n div 32);
    $n %= 16777216;
    $n +^= ($n * 2048);
    $n %= 16777216;
}
