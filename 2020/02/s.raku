#!/bin/env raku

# puzzle: https://adventofcode.com/2020/day/2

grammar PassPolicy {
    rule TOP { <low> '-' <up> <char> ':' <password> }

    token low      { \d+ }
    token up       { \d+ }
    token char     { <[a..zA..Z]> }
    token password { \w+ }
}

sub is-valid-p1(Str:D $rule --> Bool) {
    my $m = PassPolicy.parse($rule);
    $m<low> ≤ $m<password>.comb.grep({ $_ eq $m<char> }).elems ≤ $m<up>;
}

sub is-valid-p2(Str:D $rule --> Bool) {
    my $m = PassPolicy.parse($rule);
    my @pass = $m<password>.comb;
    ? (@pass[$m<low> - 1] eq $m<char> xor @pass[$m<up> - 1] eq $m<char>);
}

multi MAIN('test') {
    use Test;
    plan 18;

    my $m = PassPolicy.parse('1-3 a: abcde');
    is $m<low>,      1,       'lower limit is 1';
    is $m<up>,       3,       'upper limit is 3';
    is $m<char>,     'a',     'char is "a"';
    is $m<password>, 'abcde', 'password is "abcde"';

    is is-valid-p1('1-3 a: abcde'),      True, '"1-3 a: abcde" is correct';
    is is-valid-p1('1-3 b: cdefg'),     False, '"1-3 b: cdefg" is wrong';
    is is-valid-p1('2-9 c: ccccccccc'),  True, '"2-9 c: ccccccccc" is correct';

    is is-valid-p1('3-6 s: ssdsssss'),              False, '"3-6 s: ssdsssss" is wrong';
    is is-valid-p1('17-19 f: cnffsfffzhfnsffttms'), False, '"17-19 f: cnffsfffzhfnsffttms" is wrong';
    is is-valid-p1('8-11 c: tzvtwncnwvwttp'),       False, '"8-11 c: tzvtwncnwvwttp" is wrong';
    is is-valid-p1('7-8 q: rqvhnctm'),              False, '"7-8 q: rqvhnctm" is wrong';
    is is-valid-p1('7-10 b: lcbbbbcrfb'),           False, '"7-10 b: lcbbbbcrfb" is wrong';

    is is-valid-p1('7-11 g: ggghggggkgdwg'), True, '"7-11 g: ggghggggkgdwg" is correct';
    is is-valid-p1('6-11 j: jjljjtjjjjj'),   True, '"6-11 j: jjljjtjjjjj" is correct';
	is is-valid-p1('1-4 v: vvvv'),           True, '"1-4 v: vvvv" is correct';

    is is-valid-p2('1-3 a: abcde'),      True, '"1-3 a: abcde" is correct';
    is is-valid-p2('1-3 b: cdefg'),     False, '"1-3 b: cdefg" is wrong';
    is is-valid-p2('2-9 c: ccccccccc'), False, '"2-9 c: ccccccccc" is wrong';
}

multi MAIN(Str:D $f where *.IO.e) {
    my @rules = $f.IO.lines;
    put 'part 1: ', @rules».&is-valid-p1.grep(?*).elems;
    put 'part 2: ', @rules».&is-valid-p2.grep(?*).elems;
}
