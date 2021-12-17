#!/bin/env raku

grammar Packet {
    regex TOP    { <packet> <padding> }
    regex packet { <version> <body> }

    token version { <[01]> ** 3 }
    token data    { <[01]> ** 4 }
    regex padding { '0'* }

    token sub-packets-length { <[01]> ** 15 }
    token sub-packets-number { <[01]> ** 11 }

    token length-header { '0' <sub-packets-length> || '1' <sub-packets-number> }

    proto regex body { * }
    token body:sym<literal> { '100' ['1' <data>]* '0' <data> }
    regex body:sym<sum>     { '000' <length-header> <packet>+? <?{ body-match-header($<length-header>.made, $<packet>) }> }
    regex body:sym<prod>    { '001' <length-header> <packet>+? <?{ body-match-header($<length-header>.made, $<packet>) }> }
    regex body:sym<min>     { '010' <length-header> <packet>+? <?{ body-match-header($<length-header>.made, $<packet>) }> }
    regex body:sym<max>     { '011' <length-header> <packet>+? <?{ body-match-header($<length-header>.made, $<packet>) }> }
    regex body:sym<gt>      { '101' <length-header> <packet> ** 2 <?{ body-match-header($<length-header>.made, $<packet>) }> }
    regex body:sym<lt>      { '110' <length-header> <packet> ** 2 <?{ body-match-header($<length-header>.made, $<packet>) }> }
    regex body:sym<eq>      { '111' <length-header> <packet> ** 2 <?{ body-match-header($<length-header>.made, $<packet>) }> }

    sub body-match-header(Hash:D \header, Array:D \packets --> Bool:D) {
        header<length>.defined                                ??
            header<length> == packets.map({ .Str.chars }).sum !!
            header<number> == packets.elems
    }
}

class PacketActions {
    method TOP($/)    { make $<packet>.made }
    method packet($/) { make %(versum => $<version>.made + $<body>.made<versum>, value => $<body>.made<value>) }

    method version($/) { make $/.Str.parse-base(2) }
    method data($/)    { make $/.Str.parse-base(2) }

    method sub-packets-length($/) { make $/.Str.parse-base(2) }
    method sub-packets-number($/) { make $/.Str.parse-base(2) }

    method length-header($/) {
        make $<sub-packets-length>.defined           ??
             %(length => $<sub-packets-length>.made) !!
             %(number => $<sub-packets-number>.made)
    }

    method body:sym<literal>($/) { make %(versum => 0, value => $<data>».made.reduce({ $^a * 16 + $^b })) }

    method body:sym<sum>($/)  { make %(versum => $<packet>.map({ .made<versum> }).sum, value => [+]   $<packet>.map({ .made<value> })) }
    method body:sym<prod>($/) { make %(versum => $<packet>.map({ .made<versum> }).sum, value => [*]   $<packet>.map({ .made<value> })) }
    method body:sym<min>($/)  { make %(versum => $<packet>.map({ .made<versum> }).sum, value => $<packet>.map({ .made<value> }).min) }
    method body:sym<max>($/)  { make %(versum => $<packet>.map({ .made<versum> }).sum, value => $<packet>.map({ .made<value> }).max) }
    method body:sym<gt>($/)   { make %(versum => $<packet>.map({ .made<versum> }).sum, value => +[>]  $<packet>.map({ .made<value> })) }
    method body:sym<lt>($/)   { make %(versum => $<packet>.map({ .made<versum> }).sum, value => +[<]  $<packet>.map({ .made<value> })) }
    method body:sym<eq>($/)   { make %(versum => $<packet>.map({ .made<versum> }).sum, value => +[==] $<packet>.map({ .made<value> })) }
}

sub solve(Str:D \hs) {
    my \ss = hs.comb».map({ $_.parse-base(16).fmt('%04b') }).join;
    Packet.parse(ss, :actions(PacketActions)).made
}

multi sub MAIN('test') {
    use Test;

    is Packet.parse('010',  :rule<version>, :actions(PacketActions)).made, 2,  'version 010 => 2';
    is Packet.parse('1111', :rule<data>,    :actions(PacketActions)).made, 15, 'data 1111 => 15';

    is-deeply
        Packet.parse('10001001', :rule<body>, :actions(PacketActions)).made,
        %(versum => 0, value => 9),
        'body 10001001 => [0, 9]';
    is-deeply
        Packet.parse('1001000100010', :rule<body>, :actions(PacketActions)).made,
        %(versum => 0, value => 18),
        'body 10001001 => [0, 18]';

    is-deeply solve('D2FE28'), %(versum => 6, value => 2021), 'D2FE28 => [6, 2021]';

    is-deeply solve('38006F45291200'), %(versum => 9, value => 1), '38006F45291200 => lt(10, 20) => [9, 1]';
    is-deeply solve('EE00D40C823060'), %(versum => 14, value => 3), 'EE00D40C823060 => max(1,2,3) => [14, 3]';

    is solve('8A004A801A8002F478')<versum>, 16, '8A004A801A8002F478 version sum is 16';
    is solve('620080001611562C8802118E34')<versum>, 12, '620080001611562C8802118E34 version sum is 12';
    is solve('C0015000016115A2E0802F182340')<versum>, 23, 'C0015000016115A2E0802F182340 version sum is 23';
    is solve('A0016C880162017C3686B18A3D4780')<versum>, 31, 'A0016C880162017C3686B18A3D4780 version sum is 31';

    is solve('C200B40A82')<value>, 3, 'C200B40A82 => sum(1,2) => 3';
    is solve('04005AC33890')<value>, 54, '04005AC33890 => prod(6,9) => 54';
    is solve('880086C3E88112')<value>, 7, '880086C3E88112 => min(7,8,9) => 7';
    is solve('CE00C43D881120')<value>, 9, 'CE00C43D881120 => max(7,8,9) => 9';
    is solve('D8005AC2A8F0')<value>, 1, 'D8005AC2A8F0 => lt(5,15) => 1';
    is solve('F600BC2D8F')<value>, 0, 'F600BC2D8F => gt(5,15) => 0';
    is solve('9C005AC2F8F0')<value>, 0, '9C005AC2F8F0 => eq(5,15) => 0';
    is solve('9C0141080250320F1802104A08')<value>, 1, '9C0141080250320F1802104A08 => eq(sum(1,3),prod(2,2)) => 1';

    done-testing;
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my \answer = solve($f.IO.words[0]);
    put 'part 1: ', answer<versum>;
    put 'part 2: ', answer<value>;
}
