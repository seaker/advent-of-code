#!/bin/env raku

sub part1(Str:D $f) {
    my ($set-mask, $clr-mask);
    my %mem;
    for $f.IO.lines -> $line {
        my @words = $line.words;
        if @words[0] eq 'mask' {
            my @mask = @words[2].comb;
            $set-mask = @mask.map({ $_ eq '1' ?? 1 !! 0 }).join.parse-base(2);
            $clr-mask = @mask.map({ $_ eq '0' ?? 0 !! 1 }).join.parse-base(2);
        } else {
            my $address = @words[0].comb(/\w+/)[1];
            my $value = @words[2];
            %mem{ $address } = ($value +| $set-mask) +& $clr-mask;
        }
    }
    put 'part 1: ', %mem.values.sum;
}

sub part2(Str:D $f) {
    my ($or-mask, $cnt);
    my (@floating-bits, @floats);
    my %mem;
    for $f.IO.lines -> $line {
        print "line { ++$cnt }\r";
        my @words = $line.words;
        if @words[0] eq 'mask' {
            my @mask = @words[2].comb;
            $or-mask = @mask.map({ $_ !eq 'X' ?? $_ !! 0 }).join.parse-base(2);
            @floating-bits = (^@mask.elems).grep({ @mask[$_] eq 'X' });
            @floats = <0 1>;
            @floats = @floats X~ <0 1> for 1..^@floating-bits.elems;
        } else {
            my $address = @words[0].comb(/\w+/)[1] +| $or-mask;
            for @floats -> $float {
                my @addr = $address.base(2).&{ '0' x (36 - $_.chars) ~ $_ }.comb;
                @addr[@floating-bits] = $float.comb;
                %mem{ @addr.join } = @words[2];
            }
        }
    }
    put 'part 2: ', %mem.values.sum;
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    part1($f);
    part2($f);
}
