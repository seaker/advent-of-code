#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my (\sz, \limit) = do given $f {
    when 't01.txt'   { 9, 12 }
    when 'input.txt' { 73, 1024 }
}

my @m = ('.' xx sz).Array xx sz;
for ^sz {   # draw boundary
    @m[0;   $_  ] = '#';
    @m[sz-1;$_  ] = '#';
    @m[$_;  0   ] = '#';
    @m[$_;  sz-1] = '#';
}

my @lines = $f.IO.lines;
for @lines[^limit]».comb(/\d+/) -> (\col, \row) {
    @m[row+1;col+1] = '#';
}

my ($start, $end) = 1+i, sz-2+(sz-2)i;
my %dist = $start => 0;
put 'part 1: ', dijkstra(@m, $start, $end);

my ($low, $high) = limit+1, +@lines-1;
while $low < $high {
    my $mid = ($low + $high) div 2;
    print "$low,$high : $mid\r";

    my @m_ = @m.deepmap(*.clone);
    %dist = $start => 0;
    for @lines[limit..$mid]».comb(/\d+/) -> (\col, \row) {
        @m_[row+1;col+1] := '#';
    }

    if dijkstra(@m_, $start, $end) < Inf {
        $low = $mid + 1;
    } else {
        $high = $mid;
    }
}

print ' ' x 20, "\r";
put 'part 2: ', @lines[$low];

sub dijkstra(@m, \from, \to) {
    my @Q = from;
    while @Q {
        my $u = @Q.shift;
        for 1,-1,i,-i -> $delta {
            my $v = $u + $delta;
            next if @m[$v.im;$v.re] eq '#';

            my $dist = %dist{$u} + 1;
            if $dist < (%dist{$v} // Inf) {
                %dist{$v} = $dist;
                return $dist if $v == to;
                insert-sorted(@Q, $v);
            }
        }
    }
    Inf
}

sub insert-sorted(@a, Complex:D \elm) {
    my ($low, $high) = 0, +@a;
    while $low < $high {
        my $mid = ($low + $high) div 2;
        if %dist{@a[$mid]} < %dist{elm} {
            $low = $mid + 1;
        } else {
            $high = $mid;
        }
    }
    @a.splice($low, 0, elm);
}
