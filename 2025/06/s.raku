#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

sub stir(\op, *@nums) {
    given op {
        when '+' { [+] @nums }
        when '*' { [*] @nums }
    }
}

my @Q = $f.IO.lines».words;
my @ops = |@Q.pop;

put 'part 1: ', (^+@Q[0]).map({ stir(@ops[$_], @Q[*;$_]) }).sum;

my @Q2 = $f.IO.lines.head(*-1)».comb;

my $cnt-p2 = 0;
my @nums;
for (^+@Q2[0]).map({ @Q2[*;$_].join.Int }) -> $num {
    if $num == 0 {
        $cnt-p2 += stir(@ops.shift, @nums);
        @nums = [];
    } else {
        @nums.push($num);
    }
}
$cnt-p2 += stir(@ops.shift, @nums);

put 'part 2: ', $cnt-p2;
