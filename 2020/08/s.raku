#!/bin/env raku

grammar Instruction {
    rule TOP     { <op> <number> }
    token op     { <[a..z]> ** 3 }
    token number { ['+'|'-'] \d+ }
}

sub exec-inst(Array:D $m, UInt:D $pc is rw, Int:D $ac is rw) {
    given $m[$pc]<op> {
        when 'nop' { ++$pc }
        when 'acc' { $ac += $m[$pc]<number>; ++$pc }
        when 'jmp' { $pc += $m[$pc]<number> }
    }
}

sub run(Array:D $m, UInt:D $pc is rw, Int:D $ac is rw, Set:D $rec is rw --> Int) {
    loop {
        return $ac if $pc ∈  $rec or $pc ≥ $m.elems;
        $rec (|)= ($pc).Set;
        exec-inst($m, $pc, $ac);
    }
}

multi MAIN('test') {
    use Test;
    plan 3;

    my $m = Instruction.parse('nop +0');
    ok ?$m, "'nop +0' is ok";
    is $m<op>,     'nop', 'op is nop';
    is $m<number>, '+0',  'number is +0';
}

multi MAIN(Str:D $f where *.IO.e) {
    my Array $m = $f.IO.lines».&{ my $m = Instruction.parse($_); { op => ~$m<op>, number => ~$m<number> } }.Array;
    put 'part 1: ', run($m, my UInt $pc = 0, my Int $ac = 0, my Set $rec .= new);

    for ^$m.elems -> $i {
        next if $m[$i]<op> eq 'acc';

        temp $m[$i]<op>;
        $m[$i]<op> = $m[$i]<op> eq 'nop' ?? 'jmp' !! 'nop';
        run($m, my UInt $pc = 0, my Int $ac = 0, my Set $rec .= new);

        { put "part 2: $ac"; last } if $pc ≥ $m.elems;
    }
}
