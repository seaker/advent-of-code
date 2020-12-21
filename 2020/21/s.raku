#!/bin/env raku

grammar Foods {
    rule TOP { <ingredient>+ %% ' ' '(' 'contains' <allergen>+ %% ',' ')' }
    token ingredient { \w+ }
    token allergen   { \w+ }
}

class FoodsActions {
    method TOP($/) { make {
            ingredients => $<ingredient>.map(*.made).Array,
            allergens   => $<allergen>.map(*.made).Array
        }
    }
    method ingredient($/) { make $/.Str }
    method allergen($/)   { make $/.Str }
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @rules .= push(Foods.parse($_, :actions(FoodsActions)).made) for $f.IO.lines;
    my Set $allergens .= new(@rules.map({ |$_<allergens> }));

    my Hash $candidates;
    for $allergens.keys -> $alg {
        $candidates{$alg} = [(&)] @rules.grep({ $alg ∈ $_<allergens> }).map({ $_<ingredients> });
    }

    my (%mapping, @mapped);
    while %mapping.elems < $allergens.elems {
        for $candidates.keys -> $cand {
            if $candidates{$cand}.keys.elems == 1 {
                %mapping{$cand} = $candidates{$cand}.keys.first;
                @mapped.push(%mapping{$cand});
                $candidates{$cand}:delete;
            }
        }

        $candidates{$_} (-)= @mapped for $candidates.keys;
    }

    put 'part 1: ', [+] (@rules.map({ ($_<ingredients> (-) @mapped).elems }));
    put 'part 2: ', %mapping.sort.map(*.value).join(',');
}
