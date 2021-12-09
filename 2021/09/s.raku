#!/bin/env raku

my UInt ($rows, $cols);

sub is-lower(UInt:D \val, Hash:D \nums, Str:D \key --> Bool:D) {
    my (\row, \col) = key.split(';')».Int;

    row < 0 || row ≥ $rows ||
    col < 0 || col ≥ $cols ||
    val < nums{key}
}

sub is-low(Hash:D \nums, Str:D \key --> Bool:D) {
    my (\row, \col) = key.split(';')».UInt;

    so all(
        is-lower(nums{key}, nums, "{ row-1 };{ col   }"),
        is-lower(nums{key}, nums, "{ row   };{ col-1 }"),
        is-lower(nums{key}, nums, "{ row   };{ col+1 }"),
        is-lower(nums{key}, nums, "{ row+1 };{ col   }")
    )
}

sub promote-neighbor(Hash:D $h, Str:D \low-key, Hash:D \nums, Str:D \key) {
    my (\row, \col) = key.split(';')».Int;

    $h{key} = $h{low-key} if
        0 ≤ row < $rows &&
        0 ≤ col < $cols &&
        nums{key} != 9  &&
        (!$h{key}.defined || $h{key} ne low-key);
}

sub promote-cell(Hash:D $h, Hash:D $nums, Str:D \key) {
    my (\row, \col) = key.split(';')».UInt;

    promote-neighbor($h, $h{key}, $nums, "{ row-1 };{ col   }");
    promote-neighbor($h, $h{key}, $nums, "{ row   };{ col-1 }");
    promote-neighbor($h, $h{key}, $nums, "{ row   };{ col+1 }");
    promote-neighbor($h, $h{key}, $nums, "{ row+1 };{ col   }");
}

sub MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my $n .= push([.comb».UInt]) for $f.IO.lines;
    $rows = $n.elems;
    $cols = $n[0].elems;

    my Hash $nums .= new;
    (^$n.elems X ^$n[0].elems).map({ $nums{ "{ .[0] };{ .[1] }" } = $n[.[0];.[1]] });

    my Hash $h .= new;
    $nums.keys.map({ $h{$_} = $_ if is-low($nums, $_) });
    put 'part 1: ', $h.keys.map({ $nums{$_} + 1 }).sum;

    loop {
        my Hash $nh = $h.clone;
        promote-cell($nh, $nums, $_) for $h.keys;
        last if $nh.elems == $h.elems;
        $h = $nh.clone;
    }
    put 'part 2: ', [*] $h.values.sort.unique.map(-> \v { $h.keys.grep(-> \k { $h{k} === v }).elems }).sort[*-3..*];
}
