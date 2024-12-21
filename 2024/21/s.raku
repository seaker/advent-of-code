#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

#`[
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+
#]
my @npad =
    [<# # # # #>],
    [<# 7 8 9 #>».Str],
    [<# 4 5 6 #>».Str],
    [<# 1 2 3 #>».Str],
    [<# # 0 A #>».Str],
    [<# # # # #>],
;

my (%npad, %np-keys); 
for <0 1 2 3 4 5 6 7 8 9 A>».Str -> $c {
    with @npad[*;*].first($c, :k) -> \ndx {
        with ndx % 5 + (ndx div 5)i {
            %npad{$_} = $c;
            %np-keys{$c} = $_;
        }
    }
}

my (%np2dp, %npad-prev);
for %np-keys.keys -> $c {
    my $start = %np-keys{$c};
    %npad-prev{$c} = ().Hash;
    dijkstra(%npad, $start, %npad-prev{$c});

    %np2dp{$c} = ().Hash;
    generate-codes($c, %np-keys, %npad, %npad-prev{$c}, %np2dp{$c});
}

#`[
    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
#]
my @dpad =
    [<# # # # #>],
    [<# # ^ A #>],
    [<# \< v \> #>],
    [<# # # # #>],
;

my (%dpad, %dp-keys); 
for <^ \> v \< A> -> $c {
    with @dpad[*;*].first($c, :k) -> \ndx {
        with ndx % 5 + (ndx div 5)i {
            %dpad{$_} = $c;
            %dp-keys{$c} = $_;
        }
    }
}

my (%dp2dp, %dpad-prev);
for %dp-keys.keys -> $c {
    my $start = %dp-keys{$c};
    %dpad-prev{$c} = ().Hash;
    dijkstra(%dpad, $start, %dpad-prev{$c});

    %dp2dp{$c} = ().Hash;
    generate-codes($c, %dp-keys, %dpad, %dpad-prev{$c}, %dp2dp{$c});
}

my @mem = ().Hash for ^26;
for %dp-keys.keys X %dp-keys.keys -> ($c1, $c2) {
    @mem[0]{$c1~$c2} = %dp2dp{$c1}{$c2}[0].chars;
}

my ($cnt-p1, $cnt-p2) X= 0;
for $f.IO.words -> $code {
    my @a = ([X] ['A', |$code.comb].rotor(2 => -1).map(-> ($c1, $c2) { %np2dp{$c1}{$c2} }))».join;
    $cnt-p1 += $code.substr(0, *-1) * @a.map({ solve($_, 2)  }).min;
    $cnt-p2 += $code.substr(0, *-1) * @a.map({ solve($_, 25) }).min;
}
put 'part 1: ', $cnt-p1;
put 'part 2: ', $cnt-p2;

sub dig(Str:D $c1, Str:D $c2, UInt:D $depth --> UInt:D) {
    my $key = $c1 ~ $c2;
    without @mem[$depth]{$key} {
        @mem[$depth]{$key} = %dp2dp{$c1}{$c2}.map(-> $seq {
            ('A' ~ $seq).comb.rotor(2 => -1).map(-> ($c1, $c2) { dig($c1, $c2, $depth - 1) }).sum
        }).min;
    }
    @mem[$depth]{$key}
}

sub solve(Str:D $seq, UInt:D $depth where * > 0 --> UInt:D) {
    ('A' ~ $seq).comb.rotor(2 => -1).map(-> ($c1, $c2) { dig($c1, $c2, $depth - 1) }).sum
}

sub delta-to-dir(\delta) {
    given delta {
        when  1 { '>' }
        when -1 { '<' }
        when  i { 'v' }
        when -i { '^' }
    }
}

sub codes($start, $end, %keys, %pad, %prev) {
    return [''] if $end == $start;

    %prev{$end}.map(-> $pos {
        |codes($start, $pos, %keys, %pad, %prev).map({ $_ ~ delta-to-dir($end - $pos) }),
    }).flat
}

sub generate-codes($from, %keys, %pad, %prev, %code-map) {
    for %keys.keys -> $c {
        my @a = codes(%keys{$from}, %keys{$c}, %keys, %pad, %prev);
        %code-map{$c} = [@a.map({ $_ ~ 'A' })];
    }
}

sub dijkstra(%m, $start, %prev) {
    my %dist = $start => 0;
    my @Q = $start;
    while @Q {
        my $u = @Q.shift;
        for 1,-1,i,-i -> $delta {
            my $v = ($u + $delta).Complex;
            next without %m{$v};
            next if %m{$v} eq '#';

            my $dist = %dist{$u} + 1;
            if $dist < (%dist{$v} // Inf) {
                %dist{$v} = $dist;
                %prev{$v} = [$u];
                insert-sorted(@Q, $v, %dist);
            } elsif $dist == (%dist{$v} // Inf) {
                %prev{$v}.push($u);
            }
        }
    }
}

sub insert-sorted(@a, Complex:D \elm, %dist) {
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
