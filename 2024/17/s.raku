#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

subset Operand of UInt where 0 ≤ * ≤ 7;

class Machine {
    has Int $.A is rw;
    has Int $.B;
    has Int $.C;
    has UInt $.ip = 0;      # instruction pointer
    has @.program;
    has @.output;

    method combo(Operand $n --> Int:D) {
        given $n {
            when 0|1|2|3 { $n  }
            when 4       { $!A }
            when 5       { $!B }
            when 6       { $!C }
        }
    }
    method adv(Operand $n) { $!A div= 2**&.combo($n) }              # 0
    method bxl(Operand $n) { $!B +^= $n }                           # 1
    method bst(Operand $n) { $!B = &.combo($n) % 8 }                # 2
    method jnz(Operand $n) { $!ip = ($!A == 0 ?? $!ip+2 !! $n) }    # 3
    method bxc(Operand $_) { $!B +^= $!C }                          # 4
    method out(Operand $n) { @!output.push(&.combo($n) % 8) }       # 5
    method bdv(Operand $n) { $!B = $!A div 2**&.combo($n) }         # 6
    method cdv(Operand $n) { $!C = $!A div 2**&.combo($n) }         # 7
    method operate($op, $n) {
        given $op {
            when 0 { &.adv($n); }
            when 1 { &.bxl($n); }
            when 2 { &.bst($n); }
            when 3 { &.jnz($n); }
            when 4 { &.bxc($n); }
            when 5 { &.out($n); }
            when 6 { &.bdv($n); }
            when 7 { &.cdv($n); }
        }
    }
    method run {
        while $!ip < +@!program {
            with @!program[$!ip], @!program[$!ip+1] -> (\op, \opr) {
                &.operate(op, opr);
                $!ip += 2 if op != 3;
            }
        }
    }
}

my $m0 = do with $f.IO.slurp.comb(/\d+/)».Int {
    Machine.new(:A(.[0]), :B(.[1]), :C(.[2]), :program(.tail(*-3)));
}
with $m0.clone {
    .run;
    put 'part 1: ', .output.join(',');
}

my @target = $m0.program;
my ($n, $sz) = 0, 1;
while $sz ≤ +@target {
    with $m0.clone {
        .A = $n;
        .run;
        if .output eqv @target.tail($sz).Array {
            if $sz == +@target {
                put 'part 2: ', $n;
                last;
            }
            $n *= 8;
            ++$sz;
            next;
        }
    }
    ++$n;
}
