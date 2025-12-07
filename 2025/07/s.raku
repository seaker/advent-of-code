#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my @room = $f.IO.lines.map(*.comb.Array);
my %beams = @room[0].first('S', :k).SetHash;

my $cnt-p1 = 0;
for @room[1..*] -> @line {
    my %beams_ is SetHash;
    for %beams.keys -> $beam {
        if @line[$beam] eq '^' {
            %beams_.set([$beam-1, $beam+1]);
            ++$cnt-p1;
        } else {
            %beams_.set($beam);
        }
    }
    %beams = %beams_;
}
put 'part 1: ', $cnt-p1;

my (\rows, \cols) = +@room, +@room[0];
my %mem = (^cols).map({ "{rows-1},$_" => 1 });

sub walk(\row, \col) {
    my $key = "{row},{col}";
    return %mem{$key} with %mem{$key};

    %mem{$key} = do if @room[row+1;col] eq '^' {
        walk(row+1,col-1) + walk(row+1,col+1)
    } else {
        walk(row+1,col)
    }

    %mem{$key}
}

put 'part 2: ', walk(0, @room[0].first('S', :k));
