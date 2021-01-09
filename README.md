# Prolexa # 
## Problems Prolexa understands ## 
Prolexa is able to understand a number of the examples on <https://rule-reasoning.apps.allenai.org/>, including:
- Nails are made of iron, which is a metal, which conducts electricity. Ask: Nails conduct electricity.
- Harry can do magic, and if you can do magic you can vanish. Ask: Harry can vanish. Mr Dursley can vanish.
- Ostriches and wounded birds can't fly. Can Bill the ostrich fly?
- Now suppose birds typically don't fly, but ostriches can fly. Can Bill the ostrich now fly?
- Attributes with negation: Gary is blue. If something is not round then it is cold. Cold things are quiet. Ask: Gary is quiet.

### Conducting electricity ###
```
prolexa> "Metals conduct electricity".
*** utterance(Metals conduct electricity)
*** rule([(conduct(_47964,=>(_48300,electricity(_48300))):-metal(_47964))])
*** answer(I will remember that Metals conduct electricity)
I will remember that Metals conduct electricity
prolexa> "Insulators do not conduct electricity".
*** utterance(Insulators do not conduct electricity)
*** rule([(not(conduct(_49032,=>(_49150,electricity(_49150)))):-insulator(_49032))])
*** answer(I will remember that Insulators do not conduct electricity)
I will remember that Insulators do not conduct electricity
prolexa> "If something is made of iron then it is metal".
*** utterance(If something is made of iron then it is metal)
*** rule([(metal(_50072):-iron(_50072))])
*** answer(I will remember that If something is made of iron then it is metal)
I will remember that If something is made of iron then it is metal
prolexa> "Nails are made of iron".
*** utterance(Nails are made of iron)
*** rule([(iron(_50742):-nail(_50742))])
*** answer(I will remember that Nails are made of iron)
I will remember that Nails are made of iron
prolexa> "do nails conduct electricity".
*** utterance(do nails conduct electricity)
*** query([(conduct(_51440,=>(_51558,electricity(_51558))):-nail(_51440))])
*** answer(every nail conducts electricity)
every nail conducts electricity
```

### Harry Potter ### 
```
prolexa> "Harry can do magic".
*** utterance(Harry can do magic)
*** rule([(do(harry,=>(_3600,magic(_3600))):-true)])
*** answer(I will remember that Harry can do magic)
I will remember that Harry can do magic
prolexa> "Muggles cannot do magic".
*** utterance(Muggles cannot do magic)
*** rule([(not(do(_4204,=>(_4322,magic(_4322)))):-muggle(_4204))])
*** answer(I will remember that Muggles cannot do magic)
I will remember that Muggles cannot do magic
prolexa> "If a person can do magic then they can vanish".
*** utterance(If a person can do magic then they can vanish)
*** rule([(vanish(_5240):-do(_5240,=>(_5312,magic(_5312))))])
*** answer(I will remember that If a person can do magic then they can vanish)
I will remember that If a person can do magic then they can vanish
prolexa> "Mr Dursley is a Muggle".
*** utterance(Mr Dursley is a Muggle)
*** rule([(muggle(mr_dursley):-true)])
*** answer(I will remember that Mr Dursley is a Muggle)
I will remember that Mr Dursley is a Muggle
prolexa> "can harry vanish".
*** utterance(can harry vanish)
*** query(vanish(harry))
*** answer(harry vanishes)
harry vanishes
prolexa> "can mr dursley vanish".
*** utterance(can mr dursley vanish)
*** query(vanish(mr_dursley))
*** answer(Sorry, I don't think this is the case)
Sorry, I don't think this is the case
```
For the final question Prolexa replies with "Sorry, I don't think this is the case" which is Prolexa's version of "I don't know". The answer given by the rule reasoning site is that My Dursley cannot vanish, however I believe this to be the incorrect interpretation. Just because we have ```A => B```, does not mean that we have ```¬A => ¬B```. Moreover, for Prolexa to be able to confidently proclaim that Mr Dursley cannot vanish, Prolexa would also have to confidently refute anything they did not have hard evidence for. For exmaple, the following would have to be the case: 
```
prolexa> "tell me all you know".
*** utterance(tell me all you know)
*** goal(all_rules(_48546))
*** answer(I know nothing)
I know nothing
prolexa> "is jack human".
*** utterance(is jack human)
*** query(human(jack))
jack is not human
```
This is clearly unwanted behaviour. 

### Ostriches ### 
```g
prolexa> "Arthur is a bird".
*** utterance(Arthur is a bird)
*** rule([(bird(arthur):-true)])
*** answer(I will remember that Arthur is a bird)
I will remember that Arthur is a bird
prolexa> "Arthur is not wounded".
*** utterance(Arthur is not wounded)
*** rule([(not(wounded(arthur)):-true)])
*** answer(I will remember that Arthur is not wounded)
I will remember that Arthur is not wounded
prolexa> "Bill is an ostrich".
*** utterance(Bill is an ostrich)
*** rule([(ostrich(bill):-true)])
*** answer(I will remember that Bill is an ostrich)
I will remember that Bill is an ostrich
prolexa> "Colin is a bird".
*** utterance(Colin is a bird)
*** rule([(bird(colin):-true)])
*** answer(I will remember that Colin is a bird)
I will remember that Colin is a bird
prolexa> "Colin is wounded".
*** utterance(Colin is wounded)
*** rule([(wounded(colin):-true)])
*** answer(I will remember that Colin is wounded)
I will remember that Colin is wounded
prolexa> "Dave is not an ostrich".
*** utterance(Dave is not an ostrich)
*** rule([(not(ostrich(dave)):-true)])
*** answer(I will remember that Dave is not an ostrich)
I will remember that Dave is not an ostrich
prolexa> "Dave is wounded".
*** utterance(Dave is wounded)
*** rule([(wounded(dave):-true)])
*** answer(I will remember that Dave is wounded)
I will remember that Dave is wounded
prolexa> "If someone is an ostrich then they are a bird".
*** utterance(If someone is an ostrich then they are a bird)
*** rule([(bird(_7852):-ostrich(_7852))])
*** answer(I will remember that If someone is an ostrich then they are a bird)
I will remember that If someone is an ostrich then they are a bird
prolexa> "If someone is an ostrich then they are abnormal".
*** utterance(If someone is an ostrich then they are abnormal)
*** rule([(abnormal(_8818):-ostrich(_8818))])
*** answer(I will remember that If someone is an ostrich then they are abnormal)
I will remember that If someone is an ostrich then they are abnormal
prolexa> "If someone is an ostrich then they cannot fly".
*** utterance(If someone is an ostrich then they cannot fly)
*** rule([(not(fly(_9770)):-ostrich(_9770))])
*** answer(I will remember that If someone is an ostrich then they cannot fly)
I will remember that If someone is an ostrich then they cannot fly
prolexa> "If someone is a bird and wounded then they are abnormal".
*** utterance(If someone is a bird and wounded then they are abnormal)
*** rule([(abnormal(_10854):-bird(_10854),wounded(_10854))])
*** answer(I will remember that If someone is a bird and wounded then they are abnormal)
I will remember that If someone is a bird and wounded then they are abnormal
prolexa> "If someone is wounded then they cannot fly".
*** utterance(If someone is wounded then they cannot fly)
*** rule([(not(fly(_11802)):-wounded(_11802))])
*** answer(I will remember that If someone is wounded then they cannot fly)
I will remember that If someone is wounded then they cannot fly
prolexa> "If someone is a bird and not abnormal then they can fly".
*** utterance(If someone is a bird and not abnormal then they can fly)
*** rule([(fly(_12916):-bird(_12916),not(abnormal(_12916)))])
*** answer(I will remember that If someone is a bird and not abnormal then they can fly)
I will remember that If someone is a bird and not abnormal then they can fly
prolexa> "can arthur fly".
*** utterance(can arthur fly)
*** query(fly(arthur))
*** answer(arthur flies)
arthur flies
prolexa> "can bill fly".
*** utterance(can bill fly)
*** query(fly(bill))
*** answer(bill cannot fly)
bill cannot fly
prolexa> "can colin fly".
*** utterance(can colin fly)
*** query(fly(colin))
*** answer(colin cannot fly)
colin cannot fly
prolexa> "can dave fly".
*** utterance(can dave fly)
*** query(fly(dave))
*** answer(dave cannot fly)
dave cannot fly
```

```
prolexa> "If someone is an ostrich then they can fly".
*** utterance(If someone is an ostrich then they can fly)
*** rule([(fly(_48484):-ostrich(_48484))])
*** answer(I will remember that If someone is an ostrich then they can fly)
I will remember that If someone is an ostrich then they can fly
prolexa> "If someone is an ostrich then they are a bird".
*** utterance(If someone is an ostrich then they are a bird)
*** rule([(bird(_49462):-ostrich(_49462))])
*** answer(I will remember that If someone is an ostrich then they are a bird)
I will remember that If someone is an ostrich then they are a bird
prolexa> "If someone is a bird and not abnormal then they cannot fly".
*** utterance(If someone is a bird and not abnormal then they cannot fly)
*** rule([(not(fly(_50598)):-bird(_50598),not(abnormal(_50598)))])
*** answer(I will remember that If someone is a bird and not abnormal then they cannot fly)
I will remember that If someone is a bird and not abnormal then they cannot fly
prolexa> "If someone can fly then they are abnormal".
*** utterance(If someone can fly then they are abnormal)
*** rule([(abnormal(_51536):-fly(_51536))])
*** answer(I will remember that If someone can fly then they are abnormal)
I will remember that If someone can fly then they are abnormal
prolexa> "Arthur is a bird".
*** utterance(Arthur is a bird)
*** rule([(bird(arthur):-true)])
*** answer(I will remember that Arthur is a bird)
I will remember that Arthur is a bird
prolexa> "Bill is an ostrich".
*** utterance(Bill is an ostrich)
*** rule([(ostrich(bill):-true)])
*** answer(I will remember that Bill is an ostrich)
I will remember that Bill is an ostrich
prolexa> "can arthur fly".
*** utterance(can arthur fly)
*** query(fly(arthur))
*** answer(arthur cannot fly)
arthur cannot fly
prolexa> "can bill fly".
*** utterance(can bill fly)
*** query(fly(bill))
*** answer(bill flies)
bill flies
```

### Blue Gary ###
```
prolexa> "Gary is blue".
*** utterance(Gary is blue)
*** rule([(blue(gary):-true)])
*** answer(I will remember that Gary is blue)
I will remember that Gary is blue
prolexa> "If something is not round then it is cold".
*** utterance(If something is not round then it is cold)
*** rule([(cold(_4330):-not(round(_4330)))])
*** answer(I will remember that If something is not round then it is cold)
I will remember that If something is not round then it is cold
prolexa> "Cold things are quiet".
*** utterance(Cold things are quiet)
*** rule([(quiet(_4964):-cold(_4964))])
*** answer(I will remember that Cold things are quiet)
I will remember that Cold things are quiet
prolexa> "is gary quiet".
*** utterance(is gary quiet)
*** query(quiet(gary))
*** answer(gary is quiet)
gary is quiet
prolexa>
```


## Overview ##
This repository contains Prolog code for a simple question-answering assistant. The top-level module is `prolexa.pl`, which can either be run in the command line or with speech input and output through the 
[alexa developer console](https://developer.amazon.com/alexa/console/ask).

The heavy lifting is done in 
`prolexa_grammar.pl`, which defines DCG rules for 
sentences (that are added to the knowledge base if they don't already follow),
questions (that are answered if possible), and
commands (e.g., explain why something follows); and
`prolexa_engine.pl`, which implements reasoning by means of meta-interpreters. 

Also included are `nl_shell.pl`, which is taken verbatim from Chapter 7 of *Simply Logical*, 
and an extended version `nl_shell2.pl`, which formed the basis for the `prolexa` code. 

The code has been tested with [SWI Prolog](https://www.swi-prolog.org) versions 7.6.0 and 8.0.3. 

## Command-line interface ##

```
% swipl prolexa.pl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.0.3)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?- prolexa_cli.
prolexa> "Tell me everything you know".
*** utterance(Tell me everything you know)
*** goal(all_rules(_7210))
*** answer(every human is mortal. peter is human)
every human is mortal. peter is human
prolexa> "Peter is mortal".
*** utterance(Peter is mortal)
*** rule([(mortal(peter):-true)])
*** answer(I already knew that Peter is mortal)
I already knew that Peter is mortal
prolexa> "Explain why Peter is mortal".
*** utterance(Explain why Peter is mortal)
*** goal(explain_question(mortal(peter),_8846,_8834))
*** answer(peter is human; every human is mortal; therefore peter is mortal)
peter is human; every human is mortal; therefore peter is mortal
```


## Amazon Alexa and Prolog integration ##

Follow the steps below if you want to use the Amazon Alexa speech to text and text to speech facilities. 
This requires an HTTP interface that is exposed to the web, for which we use 
[Heroku](http://heroku.com).

### Generating intent json for Alexa ###
```
swipl -g "mk_prolexa_intents, halt." prolexa.pl
```
The intents are found in `prolexa_intents.json`. You can copy and paste the contents of this file while building your skill on the 
[alexa developer console](https://developer.amazon.com/alexa/console/ask).


### Localhost workflow (Docker) ###
To build:
```
docker build . -t prolexa
```

To run:
```
docker run -it -p 4000:4000 prolexa
```

To test the server:
```
curl -v POST http://localhost:4000/prolexa -d @testjson --header "Content-Type: application/json"
```

### Heroku workflow ###
#### Initial setup ####
Prerequisites:

- Docker app running in the background
- Installed Heroku CLI (`brew install heroku/brew/heroku`)

---

To see the status of your Heroku webapp use
```
heroku logs
```

in the prolexa directory.

---

1. Clone this repository
    ```
    git clone git@github.com:So-Cool/prolexa.git
    cd prolexa
    ```

2. Login to Heroku
    ```
    heroku login
    ```

3. Add Heroku remote
    ```
    heroku git:remote -a prolexa
    ```

#### Development workflow ####
1. Before you start open your local copy of Prolexa and login to Heroku
    ```
    cd prolexa
    heroku container:login
    ```

2. Change local files to your liking
3. Once you're done push them to Heroku
    ```
    heroku container:push web
    heroku container:release web
    ```

4. Test your skill and repeat steps *2.* and *3.* if necessary
5. Once you're done commit all the changes and push them to GitHub
    ```
    git commit -am "My commit message"
    git push origin master
    ```
