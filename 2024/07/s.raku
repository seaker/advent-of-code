#!/bin/env raku

unit sub MAIN(Str $f_?);
my $f = $f_ // 'input.txt';

my @all;
for $f.IO.lines».comb(/\d+/) -> @a is copy {
    my $t = shift @a;
    @all.push([$t, @a],);
}

my @left;
my ($sum, $cnt) X= 0;
race for @all.race -> ($t, @a) {
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
race for @left.race -> ($t, @a) {
    print "{++$cnt}\r";
    $sum += $t if calc-p2($t, @a);
}
put 'part 2: ', $sum;

sub calc-p1($target, @a --> Bool:D) {
    return False if @a[0] > $target;
    return $target == @a[0] if +@a == 1;

    my @a_ = @a.deepmap(*.clone);
    @a_.splice(0, 2, @a[0] + @a[1]);
    return True if calc-p1($target, @a_);

    @a_ = @a.deepmap(*.clone);
    @a_.splice(0, 2, @a[0] * @a[1]);
    calc-p1($target, @a_)
}

sub calc-p2($target, @a --> Bool:D) {
    return False if @a[0] > $target;
    return $target == @a[0] if +@a == 1;

    my @a_ = @a.deepmap(*.clone);
    @a_.splice(0, 2, @a[0] + @a[1]);
    return True if calc-p2($target, @a_);

    @a_ = @a.deepmap(*.clone);
    @a_.splice(0, 2, @a[0] * @a[1]);
    return True if calc-p2($target, @a_);

    @a_ = @a.deepmap(*.clone);
    @a_.splice(0, 2, @a[0] ~ @a[1]);
    calc-p2($target, @a_)
}
