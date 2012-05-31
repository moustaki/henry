#!/usr/bin/swipl -q -s 

:- module(test_suite,[run/0,tokenise_and_parse/1,failure/1,success/1]).

/**
 * Some N3 parsing tests
 * (it is clearly not exhaustive though,
 * so there may still be some bugs)
 */

:- use_module(n3_dcg).

% point it to your local SWAP installation
n3_dir('test/data').

:- dynamic failure/1,success/1.
run :-
	forall(n3_dir(Dir),
		(
		nl,
		format(' - Parsing N3 files available in ~w\n',[Dir]),
		atom_concat(Dir,'/*.n3',Wildcard),
		expand_file_name(Wildcard,Files),
		forall(member(File,Files),
			(
			nl,format(' - Parsing ~w\n',[File]),
			tokenise_and_parse(File) -> (writeln(' - Success'),assert(success(File))); (writeln(' - Failure'),assert(failure(File)))
			))
		)),
	results.

results :-
	bagof(F,failure(F),Failures),length(Failures,NF),
	bagof(S,success(S),Success),length(Success,NS),
	nl,
	format(' - ~w files successfully parsed\n',[NS]),
	format(' - ~w files not parsed\n',[NF]).

tokenise_and_parse(File) :-
        tokenise(File,Tokens),
        phrase(n3_dcg:document('',_Document),Tokens).

% And we run the tests
:- run, halt.
