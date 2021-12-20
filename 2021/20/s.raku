#!/bin/env raku

sub gen-key(SetHash:D \image, Int:D \row, Int:D \col, Int:D \min-row, Int:D \max-row, Int:D \min-col, Int:D \max-col, Bool:D \default-val --> UInt:D) {
    my $k = '';
    for -1..1 -> \rd {
        for -1..1 -> \cd {
            my (\r, \c) = row + rd, col + cd;
            $k ~= +((min-row ≤ r ≤ max-row && min-col ≤ c ≤ max-col) ?? (image{"{r};{c}"} // False) !! default-val);
        }
    }

    $k.parse-base(2);
}

sub enhance(SetHash:D \image, Array:D \code, UInt:D $round --> SetHash:D) {
    my SetHash $new-image .= new;
    my ($min-row, $max-row, $min-col, $max-col) = (∞, -∞, ∞, -∞); 
    for image.keys.map({ .split(';')».Int }) -> (\r, \c) {
        $min-row = r if r < $min-row;
        $max-row = r if r > $max-row;
        $min-col = c if c < $min-col;
        $max-col = c if c > $max-col;
    }
    my Bool $dv = (code[0] and ($round % 2) == 1);

    for ($min-row-2)..($max-row+2) X ($min-col-2)..($max-col+2) -> (\r, \c) {
        $new-image{"{r};{c}"} = code[gen-key(image, r, c, $min-row, $max-row, $min-col, $max-col, $dv)];
    }

    $new-image
}

sub solve(SetHash:D $image is copy, Array:D \code, UInt:D $rounds --> UInt:D) {
    for 1..$rounds -> $r {
        $image = enhance($image, code, $r-1);
        print "round $r: {$image.elems}\r";
    }
    print ' ' x 20, "\r";

    $image.elems
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my (\code-str, \image-str) = $f.IO.slurp.split("\n\n");
    my $code = [code-str.comb.map(* eq '#')];

    my @G .= push([$_.comb]) for image-str.lines;
    my $image = ((^@G.elems X ^@G[0].elems).map({ "{.[0]};{.[1]}" if @G[.[0];.[1]] eq '#' })).SetHash;

    put 'part 1: ', solve($image, $code, 2);
    put 'part 2: ', solve($image, $code, 50);
}
