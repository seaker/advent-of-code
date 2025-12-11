#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my %links = $f.IO.lines.map({ .[0] => .[1..*].Array with .comb(/<[a..z]>**3/) });

sub walk-p1($from) {
    state %mem = :out(1);

    return %mem{$from} with %mem{$from};

    %mem{$from} = %links{$from}.map({ walk-p1($_) }).sum;
    %mem{$from}
}

put('part 1: ', walk-p1('you')) with %links<you>;

sub walk-p2($from, @left) {
    state %mem = :out(1), :outdacfft(0), :outdac(0), :outfft(0);

    my $key = ($from, |@left).join;
    return %mem{$key} with %mem{$key};

    %mem{$key} = %links{$from}.map({ walk-p2($_, (@left (-) $from).keys.sort.Array) }).sum;
    %mem{$key}
}

put('part 2: ', walk-p2('svr', <dac fft>)) with %links<svr>;
