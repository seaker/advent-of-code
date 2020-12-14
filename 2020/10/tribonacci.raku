#!/bin/env raku

sub trib(UInt:D $i) {
    state @tribs = 1, 1, 2, *+*+* ... ∞;
    @tribs[$i];
}

put trib($_) for ^100;
