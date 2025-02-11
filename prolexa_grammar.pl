%%% Definite Clause Grammer for prolexa utterances %%%

utterance(C) --> sentence(C).
utterance(C) --> question(C).
utterance(C) --> command(C).

:- op(600, xfy, '=>').


%%% lexicon, driven by predicates %%%

adjective(_,M)		--> [Adj],    {pred2gr(_P,1,a/Adj, M)}.
noun(s,M)			--> [Noun],   {pred2gr(_P,1,n/Noun,M)}.
noun(p,M)			--> [Noun_p], {pred2gr(_P,1,n/Noun,M),noun_s2p(Noun,Noun_p)}.
noun(m,M)                       --> [Noun],   {pred2gr(_P,1,mn/Noun,M)}.
iverb(s,M)			--> [Verb_s], {pred2gr(_P,1,v/Verb,M),verb_p2s(Verb,Verb_s)}.
iverb(p,M)			--> [Verb],   {pred2gr(_P,1,v/Verb,M)}.
tverb(s,Y=>X)                   --> [Verb_s], {pred2gr(_P,2,v/Verb,Y=>X),verb_p2s(Verb,Verb_s)}.
tverb(p,Y=>X)                   --> [Verb],   {pred2gr(_P,2,v/Verb,Y=>X)}.


% predicates for adjective/nouns
pred(human,   1,[a/human,n/human]).
pred(mortal,  1,[a/mortal,n/mortal]).
pred(metal,   1,[a/metal,n/metal]).

% predicates for adjectives
pred(wounded, 1,[a/wounded]).
pred(abnormal, 1,[a/abnormal]).
pred(blue, 1,[a/blue]).
pred(round, 1,[a/round]).
pred(quiet, 1,[a/quiet]).
pred(cold, 1,[a/cold]).

% predicates for singular nouns
pred(bird,    1,[n/bird]).
pred(ostrich, 1,[n/ostrich]).
pred(dove, 1,[n/dove]).
pred(duck, 1,[n/duck]).
pred(owl, 1,[n/owl]).
pred(cat, 1,[n/cat]).
pred(muggle, 1,[n/muggle]).
pred(insulator, 1,[n/insulator]).
pred(iron, 1,[n/iron]).
pred(nail, 1,[n/nail]).

% predicates for mass nouns
pred(sand, 1,[mn/sand]).
pred(magic, 1,[mn/magic]).
pred(football, 1,[mn/football]).
pred(electricity, 1,[mn/electricity]).
pred(iron, 1,[mn/iron]).

% predicates for intransitive verbs
pred(fly,     1,[v/fly]).
pred(vanish,     1,[v/vanish]).

% predicates for transitive verbs
pred(like, 2,[v/like]).
pred(do, 2, [v/do]).
pred(play, 2, [v/play]).
pred(conduct, 2, [v/conduct]).

pred2gr(P,1,C/W,X=>Lit):-
	pred(P,1,L),
	member(C/W,L),
	Lit=..[P,X].

pred2gr(P,2,C/W,Y=>X=>Lit):-
        pred(P,2,L),
        member(C/W,L),
        Lit=..[P,X,Y].

noun_s2p(Noun_s,Noun_p):-
	( Noun_s=woman -> Noun_p=women
	; Noun_s=man -> Noun_p=men
        ; Noun_s=ostrich -> Noun_p=ostriches
	; atom_concat(Noun_s,s,Noun_p)
	).

verb_p2s(Verb_p,Verb_s):-
	( Verb_p=fly -> Verb_s=flies
        ; Verb_p=do -> Verb_s=does
        ; Verb_p=vanish -> Verb_s=vanishes
	; 	atom_concat(Verb_p,s,Verb_s)
	).


%%% sentences %%%

sentence(C) --> sword,sentence1(C).

sword --> [].
sword --> [that].

sentence1(C) --> determiner(N,M1,M2,C),noun(N,M1),verb_phrase(N,M2).
sentence1([(L:-true)]) --> proper_noun(N,X),verb_phrase(N,X=>L).
sentence1([(not(L):-true)]) --> proper_noun(N,X),negated_verb_phrase(N,X=>L).

% example: "cold things are round"
sentence1([(M1:-M2)]) --> adjective(p,M=>M2),[things],verb_phrase(p,M=>M1).

% material conditional
%       A => B
%       ¬A => B
%       A => ¬B
%       A => ¬B
sentence1([(M1:-M2)]) --> [if],pronoun(P,hypo),verb_phrase(s,M=>M2),[then],pronoun(P,concrete),verb_phrase(s,M=>M1).
sentence1([(M1:-not(M2))]) --> [if],pronoun(P,hypo),negated_verb_phrase(s,M=>M2),[then],pronoun(P,concrete),verb_phrase(s,M=>M1).
sentence1([(not(M1):-M2)]) --> [if],pronoun(P,hypo),verb_phrase(s,M=>M2),[then],pronoun(P,concrete),negated_verb_phrase(s,M=>M1).
sentence1([(not(Y):-X)]) --> noun(p,M=>X),negated_verb_phrase(p,M=>Y).

% material conditional with conjunction
%       (A & B) => C
%       (A & ¬B) => C, (¬A & B) => C
%       (A & ¬B) => ¬C, (¬A & B) => ¬C
sentence1([(M1:-X,Y)]) --> [if],pronoun(P,hypo),conjunctive_phrase(s, M=>X, M=>Y),[then],pronoun(P,concrete),verb_phrase(s,M=>M1). 
sentence1([(M1:-M3,not(M2))]) --> [if],pronoun(P,hypo),negated_conjunctive_phrase(N,M=>M3,M=>M2),[then],pronoun(P,concrete),verb_phrase(N,M=>M1).
sentence1([(not(M1):-M3,not(M2))]) --> [if],pronoun(P,hypo),negated_conjunctive_phrase(N,M=>M3,M=>M2),[then],pronoun(P,concrete),negated_verb_phrase(N,M=>M1).

% verb phrases - properties
verb_phrase(s,M) --> [is],property(s,M).
verb_phrase(p,M) --> [are],property(p,M).
verb_phrase(s,M) --> [are],property(s,M).

% verb phrases - intransitive verbs
verb_phrase(N,M) --> iverb(N,M).
verb_phrase(_,M) --> [can],iverb(p,M).

% verb phrases - transitive verbs
verb_phrase(p,X) --> tverb(p,Y=>X),noun(p,Y).
verb_phrase(p,X) --> tverb(p,Y=>X),noun(m,Y).
verb_phrase(s,X) --> tverb(s,Y=>X),noun(p,Y).
verb_phrase(s,X) --> tverb(s,Y=>X),noun(m,Y).
verb_phrase(s,X) --> [can],tverb(p,Y=>X),noun(p,Y).
verb_phrase(s,X) --> [can],tverb(p,Y=>X),noun(m,Y).

% negated verb phrases
negated_verb_phrase(s,M) --> [is,not],property(s,M).
negated_verb_phrase(_,M) --> [cannot],iverb(p,M).
negated_verb_phrase(_,X) --> [cannot],tverb(p,Y=>X),noun(m,Y).
negated_verb_phrase(_,X) --> [do,not],tverb(p,Y=>X),noun(m,Y).

% conjunctive phrases
conjunctive_phrase(s,X,Y) --> [is],property(s,X),[and],property(s,Y).

% negated conjunctive phrases
negated_conjunctive_phrase(s,X,Y) --> [is],property(s,X),[and,not],property(s,Y).
negated_conjunctive_phrase(s,Y,X) --> [is,not],property(s,X),[and],property(s,Y).

% properties
property(N,M) --> adjective(N,M).
property(s,M) --> indefinite_article,noun(s,M).
property(p,M) --> noun(p,M).
property(_,M) --> [made,of],noun(m,M).

% pronouns
pronoun(person, hypo) --> [someone].
pronoun(person, hypo) --> [a,person].
pronoun(person, concrete) --> [they].
pronoun(thing, hypo) --> [something].
pronoun(thing, concrete) --> [it].

% determiners
determiner(s,X=>B,X=>H,[(H:-B)]) --> [every].
determiner(p,X=>B,X=>H,[(H:-B)]) --> [all].
determiner(p,X=>B,X=>H,[(H:-B)]) --> [].

% indefinite articles
indefinite_article --> [a].
indefinite_article --> [an].

% proper nouns
proper_noun(s,arthur) --> [arthur].
proper_noun(s,bill) --> [bill].
proper_noun(s,colin) --> [colin].
proper_noun(s,dave) --> [dave].
proper_noun(s,gary) --> [gary].
proper_noun(s,jack) --> [jack].
proper_noun(s,harry) --> [harry].
proper_noun(s,mr_dursley) --> [mr,dursley].


%%% questions %%%

question(Q) --> qword,question1(Q).

qword --> [].
%qword --> [if].
%qword --> [whether].

question1(Q) --> [who],verb_phrase(s,_X=>Q).
question1(Q) --> [is], proper_noun(N,X),property(N,X=>Q).
question1(Q) --> [does],proper_noun(_,X),verb_phrase(_,X=>Q).
question1(Q) --> [can],proper_noun(_,X),verb_phrase(_,X=>Q).
question1([(Y:-X)]) --> [do], noun(p,M=>X) ,verb_phrase(_,M=>Y).
question1([(Y:-X)]) --> [can], noun(p,M=>X) ,verb_phrase(_,M=>Y).
question1(Q) --> [is],determiner(N,M1,M2,Q),noun(N,M1),property(N,M2).


%%% commands %%%

% These DCG rules have the form command(g(Goal,Answer)) --> <sentence>
% The idea is that if :-phrase(command(g(Goal,Answer)),UtteranceList). succeeds,
% it will instantiate Goal; if :-call(Goal). succeeds, it will instantiate Answer.
% See case C. in prolexa.pl
% Example:
%	command(g(random_fact(Fact),Fact)) --> [tell,me,anything].
% means that "tell me anything" will trigger the goal random_fact(Fact),
% which will generate a random fact as output for prolexa.

command(g(retractall(prolexa:stored_rule(_,C)),"I erased it from my memory")) --> forget,sentence(C).
command(g(retractall(prolexa:stored_rule(_,_)),"I am a blank slate")) --> forgetall.
command(g(all_rules(Answer),Answer)) --> kbdump.
command(g(all_answers(PN,Answer),Answer)) --> tellmeabout,proper_noun(s,PN).
command(g(explain_question(Q,_,Answer),Answer)) --> [explain,why],sentence1([(Q:-true)]).
command(g(random_fact(Fact),Fact)) --> getanewfact.
%command(g(pf(A),A)) --> peterflach.
%command(g(iai(A),A)) --> what.
command(g(rr(A),A)) --> thanks.

% The special form
%	command(g(true,<response>)) --> <sentence>.
% maps specific input sentences to specific responses.

command(g(true,"I can do a little bit of logical reasoning. You can talk with me about humans and birds.")) --> [what,can,you,do,for,me,minerva].
%command(g(true,"Your middle name is Adriaan")) --> [what,is,my,middle,name].
%command(g(true,"Today you can find out about postgraduate study at the University of Bristol. This presentation is about the Centre for Doctoral Training in Interactive Artificial Intelligence")) --> today.
%command(g(true,"The presenter is the Centre Director, Professor Peter Flach")) --> todaysspeaker.

thanks --> [thank,you].
thanks --> [thanks].
thanks --> [great,thanks].

getanewfact --> getanewfact1.
getanewfact --> [tell,me],getanewfact1.

getanewfact1 --> [anything].
getanewfact1 --> [a,random,fact].
getanewfact1 --> [something,i,'don\'t',know].

kbdump --> [spill,the,beans].
kbdump --> [tell,me],allyouknow.

forget --> [forget].

forgetall --> [forget],allyouknow.

allyouknow --> all.
allyouknow --> all,[you,know].

all --> [all].
all --> [everything].

tellmeabout --> [tell,me,about].
tellmeabout --> [tell,me],all,[about].

rr(A):-random_member(A,["no worries","the pleasure is entirely mine","any time, peter","happy to be of help"]).

random_fact(X):-
	random_member(X,["walruses can weigh up to 1900 kilograms", "There are two species of walrus - Pacific and Atlantic", "Walruses eat molluscs", "Walruses live in herds","Walruses have two large tusks"]).


%%% various stuff for specfic events

% today --> [what,today,is,about].
% today --> [what,is,today,about].
% today --> [what,is,happening,today].
%
% todaysspeaker --> [who,gives,'today\'s',seminar].
% todaysspeaker --> [who,gives,it].
% todaysspeaker --> [who,is,the,speaker].
%
% peterflach --> [who,is],hepf.
% peterflach --> [tell,me,more,about],hepf.
%
% what --> [what,is],iai.
% what --> [tell,me,more,about],iai.
%
% hepf --> [he].
% hepf --> [peter,flach].
%
% iai --> [that].
% iai --> [interactive,'A.I.'].
% iai --> [interactive,artificial,intelligence].
%
% pf("According to Wikipedia, Pieter Adriaan Flach is a Dutch computer scientist and a Professor of Artificial Intelligence in the Department of Computer Science at the University of Bristol.").
%
% iai("The Centre for Doctoral Training in Interactive Artificial Intelligence will train the next generation of innovators in human-in-the-loop AI systems, enabling them to responsibly solve societally important problems. You can ask Peter for more information.").
%
