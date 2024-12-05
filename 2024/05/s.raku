#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

my (\s1, \s2) = $f.IO.slurp.split("\n\n");
my %rules;
s1.lines.map({ .comb(/\d+/).Array }).map({ %rules{.[0]}.push: .[1] });

my ($sum-p1, $sum-p2) X= 0;

check-update:
for s2.lines».comb(/\d+/) -> @pages {
    for ^+@pages -> $i {
        for (%rules{@pages[$i]} // []).Array -> $p2 {
            if $i > (@pages.first($p2, :k) // Inf) {
            # a rule is broken
                shuffle-pages(@pages);
                next check-update;
            }
        }
    }
    $sum-p1 += @pages[+@pages/2];       # all rules are followed
}

put 'part 1: ', $sum-p1;
put 'part 2: ', $sum-p2;

sub shuffle-pages(*@pages) {
    my @new-pages;
    my %pages = @pages.Set;
    while +%pages {
        my %free = %pages (-) [(|)] (%rules{$_} for %pages.keys);
        @new-pages.push(|%free.keys);   # put pages that do not have to come after any other page at the front
        %pages (-)= %free;
    }
    $sum-p2 += @new-pages[+@new-pages/2];
}
