#!/bin/env raku

my @mat = (^1024).map(*.fmt('%010b').flip.parse-base(2));
my @edges;

sub parse-edge(Str:D $s where *.chars == 10) {
    $s.trans(<. #> Z=> <0 1>).parse-base(2);
}

sub parse-tile-p1(Str:D $s --> Pair) {
    my @lines = $s.lines;
    my UInt $tid = @lines[0].comb(/\d+/).first.UInt;

    $tid =>  [
        parse-edge(@lines[1]),                              # up
        parse-edge(@lines[10]),                             # down
        parse-edge(@lines[1..*].map(*.substr(0,1)).join),   # left
        parse-edge(@lines[1..*].map(*.substr(*-1)).join)    # right
    ];
}

sub parse-tile-p2(Str:D $s --> Pair) {
    my @lines = $s.lines;
    my UInt $tid = @lines[0].comb(/\d+/).first.UInt;

    $tid => @lines[2..9].map(*.substr(1,8).comb.Array).Array;
}

sub rotate-tile(Str:D $tid, UInt:D $cw where * == 1|2|3, Hash:D $tiles is rw, Hash:D $tile-images is rw) {
    my ($up, $down, $left, $right) = |$tiles{$tid};
    #put "up $up down $down left $left right $right";
    my Array $image = $tile-images{$tid};
    my Array $new-image .= push(('.' xx 8).Array) for ^8;

    given $cw {
        when 1 {    # rotate clock-wise, 90 degrees
            $tiles{$tid} = [@mat[$left], @mat[$right], $down, $up];
            ((^8) X (^8)).map({ $new-image[.[0];.[1]] = $image[.[1];7-.[0]] });
        }
        when 2 {    # rotate 180 degrees
            $tiles{$tid} = [@mat[$down], @mat[$up], @mat[$right], @mat[$left]];
            (^8).map({ $new-image[$_] = $image[7-$_].reverse.Array });
        }
        when 3 {    # rotate anti clock-wise, 90 degrees
            $tiles{$tid} = [$right, $left, @mat[$up], @mat[$down]];
            ((^8) X (^8)).map({ $new-image[.[0];.[1]] = $image[7-.[1];.[0]] });
        }
    }

    $tile-images{$tid} = $new-image;
}

# flip vertically, left <=> right
sub flip-tile(Str:D $tid, Hash:D $tiles is rw, Hash:D $tile-images is rw) { 
    my ($up, $down, $left, $right) = |$tiles{$tid};
    $tiles{$tid} = [@mat[$up], @mat[$down], $right, $left];

    my Array $image = $tile-images{$tid};
    my Array $new-image .= push(('.' xx 8).Array) for ^8;
    (^8).map({ $new-image[$_] = $image[$_].reverse.Array });
    $tile-images{$tid} = $new-image;
}

sub edge-has-match(Hash:D $tiles, UInt:D $edge, Str:D $tid --> Bool) {
    $tiles.grep({ any(|.value) == any($edge, @mat[$edge]) and .key !eq $tid }).elems > 0;
}

sub matched-edge-count(Hash:D $tiles, $tid --> UInt:D) {
    [+] $tiles{$tid}<value>.map({ +edge-has-match($tiles, $_, $tid) });
}

sub get-tid(Hash:D $tiles, UInt:D $left-edge, UInt:D $up-edge, Str:D $old-tid --> Str:D) {
    my Array $tids = $tiles
        .grep({ any(|.value) == any($left-edge, @mat[$left-edge]) })
        .grep( { $up-edge == 0??!! or any(|.value) == any($up-edge, @mat[$up-edge]) }) 
        .Hash.keys.grep(* != $old-tid).Array;
    die "multiple tiles matches $left-edge, $up-edge: { $tids.join(', ') }" if $tids.elems > 1;
    die "no tile found matches edge: $left-edge, $up-edge" if $tids.elems == 0;

    $tids.first;
}

sub install-image(Array:D $full-image is rw, UInt:D $tile-row, UInt:D $tile-col, Array:D $image) {
    my (UInt $row, UInt $col) = ($tile-row * 8, $tile-col * 8);
    #put "«{ $image[0;0] }»";
    #put "«{ $image[0;1] }»";
    ((^8) X (^8)).map({ $full-image[$row+.[0];$col+.[1]] = $image[.[0];.[1]] });
}

sub show-full-image(Array:D $full-image) {
    #put (^96).map({ $full-image[$_].join('-') }).join("\n");
    put (^96).map({ $full-image[$_].join }).join("\n");
}

multi MAIN('test') {
    use Test;

    done-testing;
}

multi MAIN('try') {
    put "$_: { @mat[$_] } " for ^1024;
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @raw-images = $f.IO.slurp.split("\n\n", :skip-empty);
    my Hash $tiles .= new(@raw-images».&parse-tile-p1);
    @edges .= push(|$_) for $tiles.values;
    #put @edges.sort.join(' ');
    #put @edges.map({ @mat[$_] }).join(', ');
    my BagHash $edge-counts .= new(|@edges, |@edges.map({ @mat[$_] }));
    #put $edge-counts.raku;
    #put ' - ' x 50;
    #put $edge-counts.elems;
    #put ' - ' x 50;
    #put $edge-counts.grep({ .value == 2 }).elems;
    #put ' - ' x 50;
    my Set $single-edges .= new($edge-counts.grep({ .value == 1 }).map({ .key }));
    my %single-counts;
    for $tiles.keys -> $k {
        if any(|$tiles{$k}) ∈ $single-edges and !(one(|$tiles{$k}) ∈ $single-edges) {
            ++%single-counts{$k};
            #put $k;
        }
    }
    #put ' - ' x 50;
    #put %single-counts.raku;
    put 'part 1: ', [*] %single-counts.keys;

    my Hash $tile-images .= new(@raw-images».&parse-tile-p2);
    my Array $full-image .= push(('.' xx 96).Array) for ^96;
    my (UInt $tile-row, UInt $tile-col) X= 0;

    my @corners = %single-counts.keys.sort;
    #put @corners.join(', ');
    my $start-tid = @corners[0];
    put "starting from $start-tid";
    put $tiles{$start-tid};
    my @start-single-edges = $single-edges.keys.grep({ $_ ∈ $tiles{$start-tid} });
    put 'rough edges ', @start-single-edges.raku;
    #put @start-single-edges.join(', ');
    rotate-tile($start-tid, 1, $tiles, $tile-images);
    put 'rotate clockwise ', $tiles{$start-tid};
    install-image($full-image, $tile-row, $tile-col++, $tile-images{$start-tid});
    #show-full-image($full-image);
    my $edge = $tiles{$start-tid}[3];
    put "right edge $edge";

    for 1..11 {
        put ' - ' x 20;
        my $new-tid = get-tid($tiles, $edge, 0, $start-tid);
        put 'next tile ', $new-tid;
        put 'next tile edges ', $tiles{$new-tid};
        put 'matched edge pos ', (^4).grep({ $tiles{$new-tid}[$_] == $edge });
        prompt 'check 1';
        rotate-tile($new-tid, 3, $tiles, $tile-images);
        put 'pos after rotation ', (^4).grep({ $tiles{$new-tid}[$_] == $edge });
        flip-tile($new-tid, $tiles, $tile-images) unless (^4).grep({ $tiles{$new-tid}[$_] == $edge });
        put 'tile edges after flip ', $tiles{$new-tid};
        put 'new matched edge pos ', (^4).grep({ $tiles{$new-tid}[$_] == any($edge, @mat[$edge]) });
        rotate-tile($new-tid, 2, $tiles, $tile-images);
        put 'tile edges in postion ', $tiles{$new-tid};
        install-image($full-image, $tile-row, $tile-col++, $tile-images{$new-tid});
        #show-full-image($full-image);

        $edge = $tiles{$new-tid}[3];
        put "right edge $edge";
    }
}
