#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

my @all = $f.IO.lines».comb(/\d+/).map(-> @a { [@a[0], @a[1..*]] });
my @left;
my ($sum, $cnt) X= 0;
for @all -> ($t, @a) {
    print "{++$cnt}\r";
    if calc-p1($t, @a) {
        $sum += $t;
    } else {
        @left.push([$t, @a],);
    }
}
put 'part 1: ', $sum;

$cnt = 0;
put +@left;
for @left -> ($t, @a) {
    print "{++$cnt}\r";
    $sum += $t if calc-p2($t, @a);
}
put 'part 2: ', $sum;

sub calc-p1($target, @a --> Bool:D) {
    return False if @a[0] > $target;
    return $target == @a[0] if +@a == 1;

    calc-p1($target, [@a[0]+@a[1], |@a[2..*]]) ||
    calc-p1($target, [@a[0]*@a[1], |@a[2..*]])
}

sub calc-p2($target, @a --> Bool:D) {
    return False if @a[0] > $target;
    return $target == @a[0] if +@a == 1;

    calc-p2($target, [@a[0]+@a[1], |@a[2..*]]) ||
    calc-p2($target, [@a[0]*@a[1], |@a[2..*]]) ||
    calc-p2($target, [@a[0]~@a[1], |@a[2..*]])
}
