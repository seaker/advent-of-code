#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my @m = $f.IO.lines.map({ .comb.Array });
my \cols = +@m[0];

my (\start-row, \start-col) = $_ div cols, $_ % cols with @m[*;*].first('S', :k);
my $start = start-col + start-row*i;
@m[start-row;start-col] = '.';

my (\end-row, \end-col) = $_ div cols, $_ % cols with @m[*;*].first('E', :k);
my $end = end-col + end-row*i;
@m[end-row;end-col] = '.';

my @Q = [$start,1],;
my %dist = "{$start},1" => 0;
my %prev;
my $best-score = Inf;

while +@Q {
    my ($u, $drt) = @Q.shift.Array;
    my $uk = "{$u},{normalize($drt)}";
    print "%dist{$uk}\r";
    last if %dist{$uk} > $best-score;

    for [0,-i],[1,1],[0,i] -> ($delta, $turn) {
    # turn left, step forward, turn right
        my $v = $u + $delta * $drt;
        my $drt_ = $drt * $turn;

        next unless @m[$v.im;$v.re] eq '.';
        if $delta == 0 {
            with $v+$drt_ { next if @m[.im;.re] eq '#'; }   # never turn to a wall
        }

        my $dist_ = %dist{$uk} + ($delta == 1 ?? 1 !! 1000);
        my $vk = "$v,{normalize($drt_)}";
        if $dist_ < (%dist{$vk} // Inf) {
            %dist{$vk} = $dist_;
            insert-sorted(@Q, [$v,$drt_]);
            %prev{$vk} = [[$u,$drt],];
            $best-score = $dist_ if $v == $end && $dist_ < $best-score;
        } elsif $dist_ == (%dist{$vk} // Inf) {             # have to keep all possible best paths for part 2
            insert-sorted(@Q, [$v,$drt_]);
            %prev{$vk}.push([$u,$drt],);
        }
    }
}
put 'part 1: ', $best-score;

my %best-paths is SetHash;
my %walked is SetHash;
back-walk($end, -1) if %dist{"{$end},1"}  // Inf == $best-score;
back-walk($end, i)  if %dist{"{$end},-i"} // Inf == $best-score;
put 'part 2: ', +%best-paths;

sub normalize($drt) {
    given $drt {
        when $drt ==  1 {  '1' }
        when $drt == -1 { '-1' }
        when $drt ==  i {  'i' }
        when $drt == -i { '-i' }
    }
}

sub insert-sorted(@a, \elm) {
    my ($low, $high) = 0, +@a;
    while $low < $high {
        my $mid = ($low + $high) div 2;
        with @a[$mid] -> $m {
            if %dist{"{$m[0]},{normalize($m[1])}"} < %dist{"{elm[0]},{normalize(elm[1])}"} {
                $low = $mid + 1;
            } else {
                $high = $mid;
            }
        }
    }
    @a.splice($low, 0, [elm,]);
}

sub back-walk($from, $drt) {
    %best-paths.set($from);
    return if $from == $start;

    my $k = "{$from},{normalize(-$drt)}";
    return if %walked{$k};      # keep away from loop holes
    %walked.set($k);
    for %prev{$k}.Array -> ($u, $drt_) {
        back-walk($u, -$drt_);
    }
}
