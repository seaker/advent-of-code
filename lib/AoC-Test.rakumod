use Test;

unit module AoC-Test;

sub aoc-test(Str:D $script, *@input) is export {
    my ($answer-p1, $answer-p2, $assertion) = @input.splice(*-3, 3);

    my $p = run $script, |@input, :out;
    my $output = $p.out.slurp(:close);

    like $output, /^^ 'part 1: ' $answer-p1 $$/, $assertion ~ " part 1: $answer-p1";
    like $output, /^^ 'part 2: ' $answer-p2 $$/, $assertion ~ " part 2: $answer-p2";
}

sub aoc-test-part(Str:D $script, *@input) is export {
    my ($answer, $assertion) = @input.splice(*-2, 2);

    my $p = run $script, |@input, :out;
    my $output = $p.out.slurp(:close);

    like $output, /^^ $answer $$/, $assertion ~ ' ' ~ $answer;
}
