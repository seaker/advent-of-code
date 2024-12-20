#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt', UInt:D $threshold is copy = 100);

my @m = $f.IO.lines.map(*.comb.Array);
my (\rows, \cols) = +@m, +@m[0];

my $start = do with @m[*;*].first('S', :k) {
    my (\row, \col) = $_ div cols, $_ % cols;
    @m[row;col] = '.';
    col + row*i
}

my $end = do with @m[*;*].first('E', :k) -> \ndx {
    my (\row, \col) = ndx div cols, ndx % cols;
    @m[row;col] = '.';
    col + row*i
}

my %dist = $start => 0;
my %prev;
my $best-dist = dijkstra(@m, $start, $end);

{
    $threshold = 10 if $f eq 't01.txt';

    my %path;
    my ($from, $d) = $end, 0;
    repeat {
        %path{$from} = $d++;
        $from = %prev{$from};
    } until $from == $start;
    %path{$from} = $best-dist;

    my $cnt-p1 = 0;
    for %path.keys».Complex -> $k {
        for 1,-1,i,-i -> $delta {
            my (\r1, \c1) = .im, .re with $k + $delta;
            next unless @m[r1;c1] eq '#';

            my (\r2, \c2) = .im, .re with $k + 2*$delta;
            next unless 0 ≤ r2 < rows && 0 ≤ c2 < cols;

            my $m = c2 + r2*i;
            next without %path{$m};

            ++$cnt-p1 if (%path{$k} - %path{$m}).abs - 2 ≥ $threshold;
        }
    }
    put 'part 1: ', $cnt-p1/2;      # every answer is counted twice
}
{
    $threshold = 70 if $f eq 't01.txt';

    my @path;
    my $from = $end;
    repeat {
        @path.push($from);
        $from = %prev{$from};
    } until $from == $start;
    @path.push($start);

    my $interval = 20;
    my $cnt-p2 = 0;
    for ^(+@path - $threshold - 3) -> $i {
        print "{$best-dist - $i}   \r";
        my $j = $i + $threshold + 2;
        while $j < +@path {
            my ($s, $e) = @path[$i, $j];
            my $dist = do with ($e - $s).Complex -> $d {
                $d.re.abs + $d.im.abs;
            }
            if $dist > $interval {
                $j += $dist - $interval;
                next;
            }

            my $save = $j - $i - $dist;
            if $save ≥ $threshold {
                ++$cnt-p2;
                ++$j;
            } else {
                $j += max(1, ($threshold - $save) div 2);
            }
        }
    }
    put 'part 2: ', $cnt-p2;
}

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
                %prev{$v} = $u;
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
