#!/bin/env raku

multi MAIN('test') {
    use Test;
    plan 1;
}

multi MAIN('try') {
}

multi MAIN(Str:D $f where *.IO.e) {
}
