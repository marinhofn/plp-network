:- module(tweet, [addTweet/2, exibirTweets/1, editarTextoTweet/2, removerTweet/2, addCurtida/2, addResposta/3, exibirMeusTweets/1, exibirMinhasCurtidas/1]).
:- use_module(library(http/json)).
:- use_module('usuario.pl').

% Fato dinâmico para gerar o id
id(0).
incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
:- dynamic id/1.

% Lendo arquivo JSON puro
lerJSON(FilePath, File) :-
    open(FilePath, read, F),
    (at_end_of_stream(F) -> File = []; json_read_dict(F, File)).

% Regras para listar todos tweets
exibirTweetsAux([]).
exibirTweetsAux([H|T]) :- 
    write("User:"), writeln(H.nome),
	write("Id:"), writeln(H.id),
    writeln(H.texto),
    write("Curtidas:"), writeln(H.nCurtidas), 
	write("Respostas:"), writeln(H.nRespostas), nl, exibirTweetsAux(T).

exibirTweets(FilePath) :-
    lerJSON(FilePath, Tweets),
    exibirTweetsAux(Tweets).

% Criando representação em formato String de um tweet em JSON
tweetToJSON(Nome, Id, Texto, NCurtidas, NRespostas, Respostas, Out) :-
	swritef(Out, '{"nome":"%w", "id":"%w", "texto":"%w", "nCurtidas":"%w", "nRespostas":"%w", "respostas": "%w"}', [Nome, Id, Texto, NCurtidas, NRespostas, Respostas]).

% Convertendo uma lista de objetos em JSON para 
tweetsToJSON([], []).
tweetsToJSON([H|T], [X|Out]) :- 
    tweetToJSON(H.nome, H.id, H.texto, H.nCurtidas, H.nRespostas, H.respostas, X), 
    tweetsToJSON(T, Out).

% Salvar em arquivo JSON
addTweet(Nome, Texto) :- 
    id(ID), incrementa_id,
    lerJSON('database/tweets.json', File),
    tweetsToJSON(File, ListaTweetsJSON),
    tweetToJSON(Nome, ID, Texto, 0, 0, "", TweetJSON),
    append(ListaTweetsJSON, [TweetJSON], Saida),
    open('database/tweets.json', write, Stream), write(Stream, Saida), close(Stream).

% Mudando o texto de um tweet
editarTextoTweet([], _, _, []).
editarTextoTweet([H|T], H.id, Texto, [_{nome:H.nome, id:H.id, texto:Texto, nCurtidas: H.nCurtidas, nRespostas: H.nRespostas, respostas: H.respostas}|T]).
editarTextoTweet([H|T], Id, Texto, [H|Out]) :- 
	editarTextoTweet(T, Id, Texto, Out).

editarTextoTweet(IdAgente, NovoNome) :-
    lerJSON('database/tweets.json', File),
    editarTextoTweet(File, IdAgente, NovoNome, SaidaParcial),
    tweetsToJSON(SaidaParcial, Saida),
    writeln(NovoNome),
    exibirTweets('database/tweets.json'),
    open('database/tweets.json', write, Stream), write(Stream, Saida), close(Stream).

% Removendo agente
removerTweet([], _, []).
removerTweet([H|T], H.id, T).
removerTweet([H|T], Id, [H|Out]) :- removerTweet(T, Id, Out).

removerTweet(FilePath, Id) :-
   lerJSON(FilePath, File),
   removerTweet(File, Id, SaidaParcial),
   tweetsToJSON(SaidaParcial, Saida),
   open(FilePath, write, Stream), write(Stream, Saida), close(Stream).


% Mudando o texto de um tweet
addCurtida([], _, []).
addCurtida([H|T], H.id, [_{nome:H.nome, id:H.id, texto:H.texto, nCurtidas: Y, nRespostas: H.nRespostas, respostas: H.respostas}|T]) :- atom_number(H.nCurtidas, X), Y is X + 1.
addCurtida([H|T], Id, [H|Out]) :- addCurtida(T, Id, Out).

addCurtida(IdTweet, Login) :-
    lerJSON('database/tweets.json', File),
    addCurtidaUsuario(Login, IdTweet),
    addCurtida(File, IdTweet, SaidaParcial),
    tweetsToJSON(SaidaParcial, Saida),
    open('database/tweets.json', write, Stream), write(Stream, Saida), close(Stream).


% Mudando o texto de um tweet
addNResposta([], _, []).
addNResposta([H|T], H.id, [_{nome:H.nome, id:H.id, texto:H.texto, nCurtidas: H.nCurtidas, nRespostas: Y, respostas: H.respostas}|T]) :- 
	atom_number(H.nRespostas, X), Y is X + 1.
addNResposta([H|T], Id, [H|Out]) :- addNResposta(T, Id, Out).

addNResposta(IdTweet) :-
    lerJSON('database/tweets.json', File),
    addNResposta(File, IdTweet, SaidaParcial),
    tweetsToJSON(SaidaParcial, Saida),
    open('database/tweets.json', write, Stream), write(Stream, Saida), close(Stream).

addResposta([], _, _, []).
addResposta([H|T], H.id, IdResposta, [_{nome:H.nome, id:H.id, texto:H.texto, nCurtidas: H.nCurtidas, nRespostas: H.nRespostas, respostas: Y}|T]) :- 
    atom_concat(IdResposta, " ", W), atom_concat(H.respostas, W, Y).
addResposta([H|T], Id, IdResposta, [H|Out]) :- addResposta(T, Id, IdResposta, Out).

addResposta(Nome, Texto, IdRespondido) :-
    addTweet(Nome, Texto),
    id(ID), writeln(ID),
    addNResposta(IdRespondido),
    lerJSON('database/tweets.json', File),
    addResposta(File, IdRespondido, ID, SaidaParcial),
    tweetsToJSON(SaidaParcial, Saida),
    open('database/tweets.json', write, Stream), write(Stream, Saida), close(Stream).


% Mudando o texto de um tweet
meusTweets([], _, []).
meusTweets([H|T], H.nome, [H|Out]) :- meusTweets(T, H.nome, Out).
meusTweets([_|T], Nome, Out) :- meusTweets(T, Nome, Out).


exibirMeusTweets(Nome) :-
    lerJSON('database/tweets.json', File),
    meusTweets(File, Nome, Lista),
    reverse(Lista, Saida),
    exibirTweetsAux(Saida).

% Mudando o texto de um tweet
minhasCurtidas([], _, []).
minhasCurtidas([H|T], ListaCurtidos, [H|Out]) :- member(H.id, ListaCurtidos), minhasCurtidas(T, ListaCurtidos, Out).
minhasCurtidas([_|T], ListaCurtidos, Out) :- minhasCurtidas(T, ListaCurtidos, Out).


exibirMinhasCurtidas(Login) :-
    listaCurtidas(Login, Lista),
    lerJSON('database/tweets.json', File),
    minhasCurtidas(File, Lista, Out),
    reverse(Out, Saida),
    exibirTweetsAux(Saida).

exibirMinhaTimeLine(Login) :-
    listaSeguidores(Login, Lista),
    lerJSON('database/tweets.json', File),
    meusSeguidores(File, Lista, Out),
    reverse(Out, Saida),
    exibirTweetsAux(Saida).

meusSeguidores([], _, []).
meusSeguidores([H|T], ListaSeguidores, [H|Out]) :- member(H.nome, ListaSeguidores), meusSeguidores(T, ListaSeguidores, Out).
meusSeguidores([_|T], ListaSeguidores, Out) :- meusSeguidores(T, ListaSeguidores, Out).