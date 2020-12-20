#!/bin/env raku

for (^1024) -> $i {
    put "{ $i.fmt('%4d') } { $i.base(2).flip.parse-base(2).fmt('%4d') }";
}

