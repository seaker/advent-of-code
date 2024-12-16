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

Search-loop:
while +@Q {
    @Q .= sort({ %dist{"{.[0]},{normalize(.[1])}"} // Inf });
    my ($u, $drt) = @Q.shift;
    my $uk = "{$u},{normalize($drt)}";
    print %dist{$uk}, "\r";
    last if %dist{$uk} > $best-score;

    for [0,-i],[1,1],[0,i] -> ($delta, $turn) {
        my $v = $u + $delta * $drt;
        my $drt_ = $drt * $turn;

        next unless @m[$v.im;$v.re] eq '.';
        if $delta == 0 {
            with $v+$drt_ -> $w {
                next if @m[$w.im;$w.re] eq '#';     # never turn to a wall
            }
        }

        my $dist_ = %dist{$uk} + ($delta == 1 ?? 1 !! 1000);
        my $vk = "$v,{normalize($drt_)}";
        if $dist_ < (%dist{$vk} // Inf) {
            %dist{$vk} = $dist_;
            @Q.push([$v, $drt_],);
            %prev{$vk} = [[$u,$drt],];
            $best-score = $dist_ if $v == $end && $dist_ < $best-score;
        } elsif $dist_ == (%dist{$vk} // Inf) {     # have to keep all possible best paths for part 2
            @Q.push([$v,$drt_],);
            %prev{$vk}.push([$u,$drt],);
        }
    }
}
put 'part 1: ', $best-score;

my %best-paths = ().SetHash;
my %walked = ().SetHash;        # keep away from loop holes when back tracking
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

sub back-walk($from, $drt) {
    %best-paths{$from} = True;
    return if $from == $start;

    my $k = "{$from},{normalize(-$drt)}";
    return if %walked{$k};
    %walked{$k} = True;
    for %prev{$k}.Array -> ($u, $drt_) {
        back-walk($u, -$drt_);
    }
}
