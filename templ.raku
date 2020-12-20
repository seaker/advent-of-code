#!/bin/env raku

multi MAIN('test') {
    use Test;

    done-testing;
}

multi MAIN('try') {
}

multi MAIN(Str:D $f where *.IO.e) {
}
