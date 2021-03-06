#!/bin/env raku

grammar Day19-P1 {
	regex rx62 { <rx93> <rx93> }
	regex rx41 { <rx40> <rx111> | <rx127> <rx70> }
	regex rx95 { <rx127> <rx93> | <rx40> <rx40> }
	regex rx73 { <rx127> <rx24> | <rx40> <rx58> }
	regex rx121 { <rx127> <rx82> | <rx40> <rx75> }
	regex rx101 { <rx93> <rx95> }
	regex rx54 { <rx127> <rx64> | <rx40> <rx112> }
	regex rx76 { <rx71> <rx40> | <rx106> <rx127> }
	regex rx25 { <rx50> <rx40> | <rx126> <rx127> }
	regex rx21 { <rx127> <rx65> }
	regex rx111 { <rx65> <rx40> | <rx57> <rx127> }
	regex rx44 { <rx127> <rx127> | <rx127> <rx40> }
	regex rx120 { <rx98> <rx127> | <rx108> <rx40> }
	regex rx59 { <rx40> <rx111> | <rx127> <rx34> }
	regex rx63 { <rx65> <rx40> | <rx65> <rx127> }
	regex rx8 { <rx42> }
	regex rx106 { <rx44> <rx40> | <rx50> <rx127> }
	regex rx98 { <rx127> <rx48> | <rx40> <rx13> }
	regex rx1 { <rx36> <rx127> | <rx74> <rx40> }
	regex rx52 { <rx127> <rx20> | <rx40> <rx114> }
	regex rx114 { <rx50> <rx127> | <rx88> <rx40> }
	regex rx2 { <rx29> <rx40> | <rx45> <rx127> }
	regex rx57 { <rx127> <rx127> | <rx40> <rx127> }
	regex rx65 { <rx40> <rx40> }
	regex rx43 { <rx40> <rx89> | <rx127> <rx73> }
	regex rx42 { <rx40> <rx69> | <rx127> <rx5> }
	regex rx110 { <rx127> <rx122> | <rx40> <rx128> }
	regex rx83 { <rx40> <rx30> | <rx127> <rx103> }
	regex rx105 { <rx110> <rx40> | <rx53> <rx127> }
	regex rx19 { <rx116> <rx127> | <rx59> <rx40> }
	regex rx90 { <rx40> <rx40> | <rx127> <rx127> }
	regex rx75 { <rx93> <rx90> }
	regex rx11 { <rx42> <rx31> }
	regex rx20 { <rx127> <rx61> | <rx40> <rx62> }
	regex rx16 { <rx83> <rx127> | <rx12> <rx40> }
	regex rx33 { <rx65> <rx127> | <rx62> <rx40> }
	regex rx4 { <rx81> <rx127> | <rx91> <rx40> }
	regex rx10 { <rx40> <rx57> }
	regex rx18 { <rx61> <rx40> | <rx62> <rx127> }
	regex rx88 { <rx40> <rx127> | <rx127> <rx40> }
	regex rx102 { <rx40> <rx109> | <rx127> <rx107> }
	regex rx49 { <rx9> <rx127> | <rx51> <rx40> }
	regex rx81 { <rx25> <rx127> | <rx84> <rx40> }
	regex rx115 { <rx104> <rx40> | <rx106> <rx127> }
	regex rx125 { <rx43> <rx40> | <rx92> <rx127> }
	regex rx9 { <rx93> <rx127> | <rx127> <rx40> }
	regex rx130 { <rx106> <rx40> | <rx67> <rx127> }
	regex rx56 { <rx95> <rx40> | <rx57> <rx127> }
	regex rx34 { <rx40> <rx44> }
	regex rx77 { <rx127> <rx55> | <rx40> <rx124> }
	regex rx79 { <rx27> <rx40> | <rx13> <rx127> }
	regex rx80 { <rx40> <rx41> | <rx127> <rx52> }
	regex rx82 { <rx126> <rx127> | <rx61> <rx40> }
	regex rx61 { <rx40> <rx40> | <rx40> <rx127> }
	regex rx27 { <rx51> <rx40> | <rx95> <rx127> }
	regex rx94 { <rx40> <rx127> | <rx93> <rx40> }
	regex rx6 { <rx78> <rx127> | <rx129> <rx40> }
	regex rx24 { <rx61> <rx127> | <rx50> <rx40> }
	regex rx126 { <rx127> <rx40> }
	regex rx108 { <rx82> <rx40> | <rx56> <rx127> }
	regex rx29 { <rx127> <rx62> | <rx40> <rx61> }
	regex rx70 { <rx127> <rx95> }
	regex rx99 { <rx90> <rx127> | <rx61> <rx40> }
	regex rx127 { 'b' }
	regex rx124 { <rx15> <rx127> | <rx120> <rx40> }
	regex rx48 { <rx40> <rx65> | <rx127> <rx50> }
	regex rx74 { <rx50> <rx127> | <rx61> <rx40> }
	regex rx55 { <rx40> <rx66> | <rx127> <rx16> }
	regex rx64 { <rx40> <rx9> }
	regex rx109 { <rx127> <rx88> | <rx40> <rx95> }
	regex rx112 { <rx40> <rx94> | <rx127> <rx9> }
	regex rx30 { <rx44> <rx127> | <rx61> <rx40> }
	regex rx47 { <rx121> <rx127> | <rx130> <rx40> }
	regex rx28 { <rx27> <rx40> | <rx56> <rx127> }
	regex rx23 { <rx48> <rx40> | <rx97> <rx127> }
	regex rx96 { <rx40> <rx95> | <rx127> <rx65> }
	regex rx37 { <rx63> <rx40> | <rx7> <rx127> }
	regex rx116 { <rx123> <rx127> | <rx36> <rx40> }
	regex rx7 { <rx40> <rx44> | <rx127> <rx65> }
	regex rx35 { <rx40> <rx127> }
	regex rx69 { <rx40> <rx125> | <rx127> <rx72> }
	regex rx36 { <rx65> <rx127> | <rx94> <rx40> }
	regex rx123 { <rx127> <rx65> | <rx40> <rx57> }
	regex rx85 { <rx40> <rx126> | <rx127> <rx65> }
	regex rx39 { <rx9> <rx127> | <rx126> <rx40> }
	regex rx26 { <rx127> <rx35> | <rx40> <rx88> }
	regex rx5 { <rx22> <rx127> | <rx100> <rx40> }
	regex rx60 { <rx40> <rx90> | <rx127> <rx65> }
	regex rx71 { <rx9> <rx127> | <rx61> <rx40> }
	regex rx78 { <rx40> <rx82> | <rx127> <rx39> }
	regex rx87 { <rx21> <rx40> | <rx101> <rx127> }
	regex rx46 { <rx126> <rx127> | <rx44> <rx40> }
	regex rx66 { <rx127> <rx54> | <rx40> <rx37> }
	regex rx13 { <rx127> <rx61> | <rx40> <rx50> }
	regex rx91 { <rx40> <rx119> | <rx127> <rx99> }
	regex rx31 { <rx77> <rx40> | <rx105> <rx127> }
	regex rx38 { <rx60> <rx40> | <rx106> <rx127> }
	regex rx128 { <rx38> <rx40> | <rx2> <rx127> }
	regex rx3 { <rx46> <rx40> | <rx49> <rx127> }
	regex rx117 { <rx44> <rx127> | <rx95> <rx40> }
	regex rx17 { <rx14> <rx40> | <rx79> <rx127> }
	regex rx84 { <rx127> <rx65> | <rx40> <rx65> }
	regex rx45 { <rx90> <rx127> | <rx95> <rx40> }
	regex rx86 { <rx127> <rx18> | <rx40> <rx85> }
	regex rx72 { <rx40> <rx80> | <rx127> <rx4> }
	regex rx103 { <rx93> <rx62> }
	regex rx50 { <rx93> <rx127> | <rx40> <rx40> }
	regex rx104 { <rx35> <rx40> | <rx65> <rx127> }
	regex rx89 { <rx117> <rx127> | <rx46> <rx40> }
	regex rx51 { <rx127> <rx127> }
	regex rx107 { <rx90> <rx40> | <rx88> <rx127> }
	regex TOP { <rx8> <rx11> }
	regex rx32 { <rx40> <rx102> | <rx127> <rx115> }
	regex rx113 { <rx96> <rx40> | <rx26> <rx127> }
	regex rx14 { <rx10> <rx40> | <rx24> <rx127> }
	regex rx58 { <rx50> <rx127> | <rx126> <rx40> }
	regex rx15 { <rx23> <rx127> | <rx87> <rx40> }
	regex rx68 { <rx1> <rx40> | <rx28> <rx127> }
	regex rx40 { 'a' }
	regex rx119 { <rx65> <rx40> | <rx50> <rx127> }
	regex rx12 { <rx40> <rx33> | <rx127> <rx56> }
	regex rx118 { <rx57> <rx127> | <rx35> <rx40> }
	regex rx122 { <rx113> <rx127> | <rx3> <rx40> }
	regex rx67 { <rx127> <rx9> | <rx40> <rx126> }
	regex rx22 { <rx68> <rx40> | <rx47> <rx127> }
	regex rx92 { <rx86> <rx40> | <rx76> <rx127> }
	regex rx93 { <rx127> | <rx40> }
	regex rx129 { <rx84> <rx127> | <rx118> <rx40> }
	regex rx97 { <rx88> <rx127> | <rx65> <rx40> }
	regex rx100 { <rx17> <rx40> | <rx19> <rx127> }
	regex rx53 { <rx40> <rx6> | <rx127> <rx32> }
}

grammar Day19-P2 {
	regex rx62 { <rx93> <rx93> }
	regex rx41 { <rx40> <rx111> | <rx127> <rx70> }
	regex rx95 { <rx127> <rx93> | <rx40> <rx40> }
	regex rx73 { <rx127> <rx24> | <rx40> <rx58> }
	regex rx121 { <rx127> <rx82> | <rx40> <rx75> }
	regex rx101 { <rx93> <rx95> }
	regex rx54 { <rx127> <rx64> | <rx40> <rx112> }
	regex rx76 { <rx71> <rx40> | <rx106> <rx127> }
	regex rx25 { <rx50> <rx40> | <rx126> <rx127> }
	regex rx21 { <rx127> <rx65> }
	regex rx111 { <rx65> <rx40> | <rx57> <rx127> }
	regex rx44 { <rx127> <rx127> | <rx127> <rx40> }
	regex rx120 { <rx98> <rx127> | <rx108> <rx40> }
	regex rx59 { <rx40> <rx111> | <rx127> <rx34> }
	regex rx63 { <rx65> <rx40> | <rx65> <rx127> }
	regex rx8 { <rx42>+ }
	regex rx106 { <rx44> <rx40> | <rx50> <rx127> }
	regex rx98 { <rx127> <rx48> | <rx40> <rx13> }
	regex rx1 { <rx36> <rx127> | <rx74> <rx40> }
	regex rx52 { <rx127> <rx20> | <rx40> <rx114> }
	regex rx114 { <rx50> <rx127> | <rx88> <rx40> }
	regex rx2 { <rx29> <rx40> | <rx45> <rx127> }
	regex rx57 { <rx127> <rx127> | <rx40> <rx127> }
	regex rx65 { <rx40> <rx40> }
	regex rx43 { <rx40> <rx89> | <rx127> <rx73> }
	regex rx42 { <rx40> <rx69> | <rx127> <rx5> }
	regex rx110 { <rx127> <rx122> | <rx40> <rx128> }
	regex rx83 { <rx40> <rx30> | <rx127> <rx103> }
	regex rx105 { <rx110> <rx40> | <rx53> <rx127> }
	regex rx19 { <rx116> <rx127> | <rx59> <rx40> }
	regex rx90 { <rx40> <rx40> | <rx127> <rx127> }
	regex rx75 { <rx93> <rx90> }
	regex rx11 { <rx42>+ <rx31>+ <?{ $<rx42> == $<rx31> }> }
	regex rx20 { <rx127> <rx61> | <rx40> <rx62> }
	regex rx16 { <rx83> <rx127> | <rx12> <rx40> }
	regex rx33 { <rx65> <rx127> | <rx62> <rx40> }
	regex rx4 { <rx81> <rx127> | <rx91> <rx40> }
	regex rx10 { <rx40> <rx57> }
	regex rx18 { <rx61> <rx40> | <rx62> <rx127> }
	regex rx88 { <rx40> <rx127> | <rx127> <rx40> }
	regex rx102 { <rx40> <rx109> | <rx127> <rx107> }
	regex rx49 { <rx9> <rx127> | <rx51> <rx40> }
	regex rx81 { <rx25> <rx127> | <rx84> <rx40> }
	regex rx115 { <rx104> <rx40> | <rx106> <rx127> }
	regex rx125 { <rx43> <rx40> | <rx92> <rx127> }
	regex rx9 { <rx93> <rx127> | <rx127> <rx40> }
	regex rx130 { <rx106> <rx40> | <rx67> <rx127> }
	regex rx56 { <rx95> <rx40> | <rx57> <rx127> }
	regex rx34 { <rx40> <rx44> }
	regex rx77 { <rx127> <rx55> | <rx40> <rx124> }
	regex rx79 { <rx27> <rx40> | <rx13> <rx127> }
	regex rx80 { <rx40> <rx41> | <rx127> <rx52> }
	regex rx82 { <rx126> <rx127> | <rx61> <rx40> }
	regex rx61 { <rx40> <rx40> | <rx40> <rx127> }
	regex rx27 { <rx51> <rx40> | <rx95> <rx127> }
	regex rx94 { <rx40> <rx127> | <rx93> <rx40> }
	regex rx6 { <rx78> <rx127> | <rx129> <rx40> }
	regex rx24 { <rx61> <rx127> | <rx50> <rx40> }
	regex rx126 { <rx127> <rx40> }
	regex rx108 { <rx82> <rx40> | <rx56> <rx127> }
	regex rx29 { <rx127> <rx62> | <rx40> <rx61> }
	regex rx70 { <rx127> <rx95> }
	regex rx99 { <rx90> <rx127> | <rx61> <rx40> }
	regex rx127 { 'b' }
	regex rx124 { <rx15> <rx127> | <rx120> <rx40> }
	regex rx48 { <rx40> <rx65> | <rx127> <rx50> }
	regex rx74 { <rx50> <rx127> | <rx61> <rx40> }
	regex rx55 { <rx40> <rx66> | <rx127> <rx16> }
	regex rx64 { <rx40> <rx9> }
	regex rx109 { <rx127> <rx88> | <rx40> <rx95> }
	regex rx112 { <rx40> <rx94> | <rx127> <rx9> }
	regex rx30 { <rx44> <rx127> | <rx61> <rx40> }
	regex rx47 { <rx121> <rx127> | <rx130> <rx40> }
	regex rx28 { <rx27> <rx40> | <rx56> <rx127> }
	regex rx23 { <rx48> <rx40> | <rx97> <rx127> }
	regex rx96 { <rx40> <rx95> | <rx127> <rx65> }
	regex rx37 { <rx63> <rx40> | <rx7> <rx127> }
	regex rx116 { <rx123> <rx127> | <rx36> <rx40> }
	regex rx7 { <rx40> <rx44> | <rx127> <rx65> }
	regex rx35 { <rx40> <rx127> }
	regex rx69 { <rx40> <rx125> | <rx127> <rx72> }
	regex rx36 { <rx65> <rx127> | <rx94> <rx40> }
	regex rx123 { <rx127> <rx65> | <rx40> <rx57> }
	regex rx85 { <rx40> <rx126> | <rx127> <rx65> }
	regex rx39 { <rx9> <rx127> | <rx126> <rx40> }
	regex rx26 { <rx127> <rx35> | <rx40> <rx88> }
	regex rx5 { <rx22> <rx127> | <rx100> <rx40> }
	regex rx60 { <rx40> <rx90> | <rx127> <rx65> }
	regex rx71 { <rx9> <rx127> | <rx61> <rx40> }
	regex rx78 { <rx40> <rx82> | <rx127> <rx39> }
	regex rx87 { <rx21> <rx40> | <rx101> <rx127> }
	regex rx46 { <rx126> <rx127> | <rx44> <rx40> }
	regex rx66 { <rx127> <rx54> | <rx40> <rx37> }
	regex rx13 { <rx127> <rx61> | <rx40> <rx50> }
	regex rx91 { <rx40> <rx119> | <rx127> <rx99> }
	regex rx31 { <rx77> <rx40> | <rx105> <rx127> }
	regex rx38 { <rx60> <rx40> | <rx106> <rx127> }
	regex rx128 { <rx38> <rx40> | <rx2> <rx127> }
	regex rx3 { <rx46> <rx40> | <rx49> <rx127> }
	regex rx117 { <rx44> <rx127> | <rx95> <rx40> }
	regex rx17 { <rx14> <rx40> | <rx79> <rx127> }
	regex rx84 { <rx127> <rx65> | <rx40> <rx65> }
	regex rx45 { <rx90> <rx127> | <rx95> <rx40> }
	regex rx86 { <rx127> <rx18> | <rx40> <rx85> }
	regex rx72 { <rx40> <rx80> | <rx127> <rx4> }
	regex rx103 { <rx93> <rx62> }
	regex rx50 { <rx93> <rx127> | <rx40> <rx40> }
	regex rx104 { <rx35> <rx40> | <rx65> <rx127> }
	regex rx89 { <rx117> <rx127> | <rx46> <rx40> }
	regex rx51 { <rx127> <rx127> }
	regex rx107 { <rx90> <rx40> | <rx88> <rx127> }
	regex TOP { <rx8> <rx11> }
	regex rx32 { <rx40> <rx102> | <rx127> <rx115> }
	regex rx113 { <rx96> <rx40> | <rx26> <rx127> }
	regex rx14 { <rx10> <rx40> | <rx24> <rx127> }
	regex rx58 { <rx50> <rx127> | <rx126> <rx40> }
	regex rx15 { <rx23> <rx127> | <rx87> <rx40> }
	regex rx68 { <rx1> <rx40> | <rx28> <rx127> }
	regex rx40 { 'a' }
	regex rx119 { <rx65> <rx40> | <rx50> <rx127> }
	regex rx12 { <rx40> <rx33> | <rx127> <rx56> }
	regex rx118 { <rx57> <rx127> | <rx35> <rx40> }
	regex rx122 { <rx113> <rx127> | <rx3> <rx40> }
	regex rx67 { <rx127> <rx9> | <rx40> <rx126> }
	regex rx22 { <rx68> <rx40> | <rx47> <rx127> }
	regex rx92 { <rx86> <rx40> | <rx76> <rx127> }
	regex rx93 { <rx127> | <rx40> }
	regex rx129 { <rx84> <rx127> | <rx118> <rx40> }
	regex rx97 { <rx88> <rx127> | <rx65> <rx40> }
	regex rx100 { <rx17> <rx40> | <rx19> <rx127> }
	regex rx53 { <rx40> <rx6> | <rx127> <rx32> }
}

multi MAIN(Str:D $f where *.IO.e = 'input.txt') {
    my @strings = $f.IO.slurp.split(/\n\n/)[1].lines;
    put 'part 1: ', @strings.grep({ ?Day19-P1.parse($_) }).elems;
    put 'part 2: ', @strings.grep({ ?Day19-P2.parse($_) }).elems;
}
