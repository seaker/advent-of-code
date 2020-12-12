#!/bin/env raku

sub passport-is-valid-p1(Str:D $s) {
    ?($s.comb(/\S+/)».comb(/<-[:]>+/).map(*[0]).sort eq any(
        <byr cid ecl eyr hcl hgt iyr pid>, <byr ecl eyr hcl hgt iyr pid>
    ));
}

sub passport-is-valid-p2(Str:D $s --> Bool) {
    my %h = $s.comb(/\S+/)».comb(/<-[:]>+/).map({ .[0] => .[1] });
    return False unless %h<byr>.defined and 1920 ≤ %h<byr> ≤ 2002;
    return False unless %h<iyr>.defined and 2010 ≤ %h<iyr> ≤ 2020;
    return False unless %h<eyr>.defined and 2020 ≤ %h<eyr> ≤ 2030;

    return False unless %h<hgt>.defined;
    given %h<hgt> {
        when /^(\d+)cm$/ { return False unless 150 ≤ $/[0] ≤ 193 }
        when /^(\d+)in$/ { return False unless  59 ≤ $/[0] ≤  76 }
        default          { return False }
    }

    return False unless %h<hcl>.defined and %h<hcl>.match(/^ '#' <xdigit> ** 6 $/);
    return False unless %h<ecl>.defined and %h<ecl> ∈  <amb blu brn gry grn hzl oth>;
    return False unless %h<pid>.defined and %h<pid>.match(/^ \d ** 9 $/);

    return ?(%h.keys.sort eq any(<byr cid ecl eyr hcl hgt iyr pid>, <byr ecl eyr hcl hgt iyr pid>));
}

sub MAIN(Str:D $f where *.IO.e) {
    my @P = $f.IO.slurp.split(/\n\n/);
    put 'part 1: ', @P».&passport-is-valid-p1.grep(?*).elems;
    put 'part 2: ', @P».&passport-is-valid-p2.grep(?*).elems;
}
