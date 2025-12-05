#!/bin/env raku

unit sub MAIN(Str:D $f where *.IO.f = 'input.txt');

subset Positive of UInt where * > 0;

class Spectrum {
    has Int      $.begin is rw;
    has Positive $.len is rw;

    method end { $!begin + $!len - 1 }

    multi method new(*%h) {
        die 'len should be positive' if %h<len> ≤ 0;
        self.bless: |%h
    }

    multi method WHICH(Spectrum:D:) { "Spectrum|{$!begin},{$!len}" }
    method Str(Spectrum:D:) { "{$!begin}..{self.end}" }

    multi method intersects(Spectrum:D: Spectrum:D \spm --> Bool:D) {
        self.end ≥ spm.begin and $!begin ≤ spm.end
    }

    method combinable(Spectrum:D: Spectrum:D \spm --> Bool:D) {
        self.end ≥ spm.begin and $!begin ≤ spm.end or
        $!begin   + $!len   == spm.begin           or
        spm.begin + spm.len == $!begin
    }

    method combine(
        Spectrum:D :
        Spectrum:D \spm,
        Bool :$die-on-error? = False
    ) {
        if !self.combinable(spm) {
            $die-on-error
                ?? die "{self} does not intersect with {spm}"
                !! return self;
        }

        my \end_ = self.end;
        $!begin  = min($!begin, spm.begin);
        $!len    = max(end_, spm.end) - $!begin + 1;

        self
    }
}

sub converge(*@S) {
    @S .= sort({ .begin, -.len });
    my @S_;
    while +@S > 1 {
        while +@S > 1 and @S[*-2].combinable(@S[*-1]) {
            my \s1 = @S.pop;
            @S[*-1].combine(s1);
        }
        @S_.unshift(@S.pop);
    }
    @S_.unshift(@S.pop) if +@S > 0;

    @S_.sort({ .begin, -.len }).Array
}

my ($in1, $in2) = $f.IO.split("\n\n");
my @ranges = $in1.lines».comb(/\d+/)».Int».minmax;

put 'part 1: ', +$in2.words.grep(-> $id { @ranges.map({ .min ≤ $id ≤ .max }).any });

my ($s, $r) = @ranges.map({ Spectrum.new(:begin(.min), :len(.max-.min+1)) }), [];
($s, $r) = converge(@$s), $s while +$r != +$s;
put 'part 2: ', @$r».len.sum;
