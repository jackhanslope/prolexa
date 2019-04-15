%%% grammar %%%

:- op(600, xfy, '=>').

%%% lexicon, driven by predicates %%%

adjective(_,M)		--> [Adj],    {pred2gr(_P,1,a/Adj, M)}.
noun(s,M)			--> [Noun],   {pred2gr(_P,1,n/Noun,M)}.
noun(p,M)			--> [Noun_p], {pred2gr(_P,1,n/Noun,M),noun_s2p(Noun,Noun_p)}.
iverb(s,M)			--> [Verb_s], {pred2gr(_P,1,v/Verb,M),verb_p2s(Verb,Verb_s)}.
iverb(p,M)			--> [Verb],   {pred2gr(_P,1,v/Verb,M)}.

% unary predicates for adjectives, nouns and verbs
pred(human,   1,[a/human,n/human]).
pred(mortal,  1,[a/mortal,n/mortal]).
%pred(man,     1,[a/male,n/man]).
%pred(woman,   1,[a/female,n/woman]).
%pred(married, 1,[a/married]).
%pred(bachelor,1,[n/bachelor]).
%pred(mammal,  1,[n/mammal]).
pred(bird,    1,[n/bird]).
%pred(bat,     1,[n/bat]).
pred(penguin, 1,[n/penguin]).
pred(sparrow, 1,[n/sparrow]).
pred(fly,     1,[v/fly]).

pred2gr(P,1,C/W,X=>Lit):-
	pred(P,1,L),
	member(C/W,L),
	Lit=..[P,X].

noun_s2p(Noun_s,Noun_p):-
	( Noun_s=woman -> Noun_p=women
	; Noun_s=man -> Noun_p=men
	; atom_concat(Noun_s,s,Noun_p)
	).

verb_p2s(Verb_p,Verb_s):-
	( Verb_p=fly -> Verb_s=flies
	; 	atom_concat(Verb_p,s,Verb_s)
	).

%%% sentences %%%

sentence(C) --> sword,sentence1(C).

sword --> [].
sword --> [that]. 

sentence1(C) --> determiner(N,M1,M2,C),noun(N,M1),verb_phrase(N,M2).
sentence1([(L:-true)]) --> proper_noun(N,X),verb_phrase(N,X=>L).
sentence1([d((H:-B,not(E)))]) --> determiner(N,X=>B,X=>H,[d(H:-B)]),noun(N,X=>B),verb_phrase(N,X=>H),exception(N,X=>E).

verb_phrase(s,M) --> [is],property(s,M).
verb_phrase(p,M) --> [are],property(p,M).
verb_phrase(N,M) --> iverb(N,M).

property(N,M) --> adjective(N,M).
property(s,M) --> [a],noun(s,M).
property(p,M) --> noun(p,M).

exception(N,M) --> [except],noun(N,M).

determiner(s,X=>B,X=>H,[(H:-B)]) --> [every].
determiner(p,X=>B,X=>H,[(H:-B)]) --> [all].
%determiner(p,X=>B,X=>H,[(H:-B)]) --> [].
determiner(p,X=>B,X=>H,[d(H:-B)])	 --> [most].
%determiner(p, sk=>H1, sk=>H2, [(H1:-true),(H2 :- true)]) -->[some].

proper_noun(s,tweety) --> [tweety].
proper_noun(s,dek) --> [dek].
proper_noun(s,peter) --> [peter].

%%% questions %%%

question(Q) --> qword,question1(Q).

qword --> [].
%qword --> [if]. 
%qword --> [whether]. 

question1(Q) --> [who],verb_phrase(s,_X=>Q).
question1(Q) --> [is], proper_noun(N,X),property(N,X=>Q).
question1(Q) --> [does],proper_noun(_,X),verb_phrase(_,X=>Q).
%question1((Q1,Q2)) --> [are,some],noun(p,sk=>Q1),
%					  property(p,sk=>Q2).

%%% commands %%%

command(g(random_fact(Fact),Fact)) --> getanewfact.
command(g(retractall(alexa_mod:sessionid_fact(_,C)),"I erased it from my memory")) --> forget,sentence(C). 
command(g(retractall(alexa_mod:sessionid_fact(_,_)),"I am a blank slate")) --> forgetall. 
command(g(all_facts(Answer),Answer)) --> kbdump. 
command(g(all_answers(PN,Answer),Answer)) --> tellmeabout,proper_noun(s,PN).
command(g(explain_question(Q,_,Answer),Answer)) --> [explain,why],sentence1([(Q:-true)]).

command(g(true,"I can do a little bit of logical reasoning. You can talk with me about humans and birds.")) --> [what,can,you,do,for,me,minerva]. 
command(g(true,"Your middle name is Adriaan")) --> [what,is,my,middle,name]. 
command(g(true,"Today is the first day of this year\'s BrisSynBio conference. The keynote is the highlight of the day.")) --> today. 
%command(g(true,"Today you can find out about ten new Centres for Doctoral Training in Bristol, including one on Interactive Artificial Intelligence")) --> today. 
command(g(true,"Today\'s keynote is given by Professor Peter Flach")) --> todaysspeaker. 
command(g(pf(A),A)) --> peterflach. 
command(g(iai(A),A)) --> what. 
command(g(rr(A),A)) --> thanks.

today --> [what,today,is,about].
today --> [what,is,today,about].
today --> [what,is,happening,today].

todaysspeaker --> [who,gives,'today\'s',seminar].
todaysspeaker --> [who,gives,it].
todaysspeaker --> [who,is,the,speaker].

peterflach --> [who,is],hepf.
peterflach --> [tell,me,more,about],hepf.

what --> [what,is],iai.
what --> [tell,me,more,about],iai.

hepf --> [he].
hepf --> [peter,flach].

iai --> [that].
iai --> [interactive,'A.I.'].
iai --> [interactive,artificial,intelligence].

pf("According to Wikipedia, Pieter Adriaan Flach is a Dutch computer scientist and a Professor of Artificial Intelligence in the Department of Computer Science at the University of Bristol.").

iai("The Centre for Doctoral Training in Interactive Artificial Intelligence will train the next generation of innovators in human-in-the-loop AI systems, enabling them to responsibly solve societally important problems. You can ask Peter for more information.").

thanks --> [thank,you].
thanks --> [thanks].
thanks --> [great,thanks].

rr(A):-random_member(A,["no worries","the pleasure is entirely mine","any time, peter","happy to be of help"]).

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


%%% generating intents from grammar %%%

utterance(C) --> sentence(C).
utterance(C) --> question(C).
utterance(C) --> command(C).

intents:-
	findall(
			_{
				%id:null,
				name:
					_{
						value:SS,
						synonyms:[]
					}
			},
		( phrase(alexa_mod:utterance(_),S),
		  atomics_to_string(S," ",SS)
		),
		L),
	% Stream=current_output,
	open('intents.json',write,Stream,[]),
	json_write(Stream,
				_{
				    interactionModel: _{
        				languageModel: _{
            				invocationName: minerva,
            				intents: [
								_{
								  name: 'AMAZON.CancelIntent',
								  samples: []
								},
								_{
								  name: 'AMAZON.HelpIntent',
								  samples: []
								},
								_{
								  name: 'AMAZON.StopIntent',
								  samples: []
								},
								_{
								  name: utterance,
								  samples: [
									'{utteranceSlot}'
								  ],
								  slots: [
									_{
									  name: utteranceSlot,
									  type: utteranceSlot,
									  samples: []
									}
								  ]
							  }
							  ],
							  types: [
									_{
										name:utteranceSlot,
										values:L
									}
								]
							}
						}
				}
			   ),
		close(Stream).

