#!/bin/env raku

# generate direction and offset mapping between two scanner sets with 2 pairs of beacons
sub gen-mapping(Str:D $i1, Str:D $i2, Str:D $j1, Str:D $j2 --> Hash:D) {
    my @cpi = $i1.split(',')».Int;
    my @cdi = $i2.split(',')».Int;
    my @cpj = $j1.split(',')».Int;
    my @cdj = $j2.split(',')».Int;

    my @diffi = (^3).map({ @cpi[$_]-@cdi[$_] });
    my @diffj = (^3).map({ @cpj[$_]-@cdj[$_] });

    return Hash.new if @diffi.map({ .abs }).unique < 3;     # not unique
    return Hash.new if @diffi.grep(* == 0).elems > 0;       # has zero value

    my Array $map-direct .= new;
    for ^3 -> \n {
        given abs(@diffi[n]) {
            when abs(@diffj[0]) { $map-direct[n] = [@diffj[0] / @diffi[n] * 1, 0, 0]; }
            when abs(@diffj[1]) { $map-direct[n] = [0, @diffj[1] / @diffi[n] * 1, 0]; }
            when abs(@diffj[2]) { $map-direct[n] = [0, 0, @diffj[2] / @diffi[n] * 1]; }
        }
    }
    my Array $map-offset = [(^3).map(->\n { @cpi[n] - (^3).map(->\k { @cpj[k]*$map-direct[n;k] }).sum })];

    %(offset => $map-offset, direction => $map-direct)
}

sub conv-coord(Int:D \x, Int:D \y, Int:D \z, Hash:D $mapping) {
    my $offsets = $mapping<offset>;
    my $orients = $mapping<direction>;
   
    x * $orients[0;0] + y * $orients[0;1] + z * $orients[0;2] + $offsets[0],
    x * $orients[1;0] + y * $orients[1;1] + z * $orients[1;2] + $offsets[1],
    x * $orients[2;0] + y * $orients[2;1] + z * $orients[2;2] + $offsets[2]
}

sub manhattan-distance(Str:D \a, Str:D \b --> UInt:D) {
    my \p0 = a.split(',')».Int;
    my \p1 = b.split(',')».Int;
    abs(p0[0] - p1[0]) + abs(p0[1] - p1[1]) + abs(p0[2] - p1[2])
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my $s    .= push([$_.lines.tail(*-1).map({ [.comb(/'-'?\d+/)».Int] })]) for $f.IO.slurp.split("\n\n");          # beacons data of scanners
    my $dist .= push([$s[$_].combinations(2).map(->(\a,\b) { (^3).map({ (a[$_]-b[$_])² }).sum })]) for ^$s.elems;   # distance squares of all pairs

    my @turns = (0).SetHash;    # the sequence for final conversions, converting into scanner 0's coordination system will be the last step
    my SetHash $scanners = (1..^$s.elems).SetHash;  # ids of scanners whose conversion turn has not been determined yet
    my $round = 0;

    my Hash $mapping .= new;
    while $scanners.elems > 0 {
        @turns[$round+1] = SetHash.new;     # scanners from @turns[n+1] will be converted into sets of scanners from @turns[n]
        for @turns[$round].keys».UInt -> $i {
            for ^$s.elems -> $j {
                next unless $j (elem) $scanners;

                my Set $di = $dist[$i] (&) $dist[$j];       # matching scanner sets by matching distances between beacons
                next if $di.elems < 12;

                my @combo-i = $s[$i].combinations(2);
                my @combo-j = $s[$j].combinations(2);
                my Array $rec .= new;
                for $di.keys -> $d {
                # locate matching beacon pairs from both sets
                    $rec.push([
                        @combo-i
                            .grep(->(\a,\b) { $d == (^3).map({ (a[$_]-b[$_])² }).sum })
                            .map(->(\a,\b) { "{a[0]},{a[1]},{a[2]}", "{b[0]},{b[1]},{b[2]}" })
                            .SetHash,
                        @combo-j
                            .grep(->(\a,\b) { $d == (^3).map({ (a[$_]-b[$_])² }).sum })
                            .map(->(\a,\b) { "{a[0]},{a[1]},{a[2]}", "{b[0]},{b[1]},{b[2]}" })
                            .SetHash
                    ])
                }

                my $sa = $rec[0];
                for 1..^$rec.elems -> \m {
                    my $spi = $sa[0] (&) $rec[m;0];
                    my $spj = $sa[1] (&) $rec[m;1];

                    if $spi.elems == $spj.elems == 1 {
                    # same beacon pair is probably nailed between two scanner sets
                        my $sdi = $sa[0] (-) $spi;
                        my $sdj = $sa[1] (-) $spj;
                        $mapping{"$i;$j"} = gen-mapping($spi.keys.first, $sdi.keys.first, $spj.keys.first, $sdj.keys.first);
                        last if $mapping{"$i;$j"}<offset>.defined;
                    }
                }
                if $mapping{"$i;$j"}<offset>.defined {
                    @turns[$round+1].set($j);   # beacons of scanner $j can be merged into scanner $i in this round
                    $scanners.unset($j);
                }
            }
        }
        ++$round;
    }

    my Array $beacons .= new;           # coords of beacons
    my Array $ss .= new;                # coords of scanners
    for ^$s.elems -> \m {
        $beacons[m] = $s[m].map({ "{.[0]},{.[1]},{.[2]}" }).SetHash;
        $ss[m] = ('0,0,0').SetHash;
    }

    # convert coords
    for ((@turns.elems-1) ... 1) -> \m {
        for @turns[m].keys -> \src {
            # merge beacons from source scanner into target scanner
            my \tgt = @turns[m-1].keys.grep(->\k { $mapping{"{k};{src}"}.defined }).first;
            my \mp = $mapping{"{tgt};{src}"};
            for $beacons[src].keys -> \c {
                my (\x, \y, \z) = conv-coord(|c.split(',')».Int, mp);
                $beacons[tgt].set("{x},{y},{z}");
            }

            # convert and merge coords of scanners
            for $ss[src].keys -> \c {
                my (\x, \y, \z) = conv-coord(|c.split(',')».Int, mp);
                $ss[tgt].set("{x},{y},{z}");
            }
        }
    }

    put 'part 1: ', $beacons[0].elems;
    put 'part 2: ', $ss[0].keys.combinations(2).map({ manhattan-distance(.[0], .[1]) }).max;
}
