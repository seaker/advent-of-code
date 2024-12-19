#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my (\s1, \s2) = $f.IO.slurp.split("\n\n");
my @towels = s1.comb(/<[bgruw]>+/);

my %mem;
my ($cnt-p1, $cnt-p2) X= 0;
my $i = 1;
for s2.words -> $design {
    print "$i\r";
    with possible($design, @towels) -> \cnt {
        $cnt-p1 += sign(cnt);
        $cnt-p2 += cnt;
    }
    ++$i;
}
put 'part 1: ', $cnt-p1;
put 'part 2: ', $cnt-p2;

sub possible(Str:D $s, @towels --> UInt:D) {
    return 1 if $s eq '';

    without %mem{$s} {
        %mem{$s} = 0;
        for @towels.grep({ $s.starts-with($_) }) -> $t {
            %mem{$s} += possible($s.substr($t.chars), @towels);
        }
    }
    %mem{$s}
}
