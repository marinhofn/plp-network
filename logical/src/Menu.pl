
:- module('Menu', [menuInicial/0]).
:- use_module('util/functionsUser.pl').
:- use_module('util/functionsTweets.pl').
:- use_module('util/input.pl',[input/1]).

menuInicial() :- 
    writeln('1 - Login'), nl,
    writeln('2 - Cadastro'), nl,
    writeln('3 - Sair\n'),
    read(Option),
    (
        Option =:= 1 -> loginTerminal();
        Option =:= 2 -> cadastroTerminal();
        Option =:= 3 -> halt(0);
        writeln('Opção inválida!'), nl,
        menuInicial()
    ).

cls :- write('\33\[2J').

loginTerminal :-
    writeln('Digite seu login: '),
    read(Login),
    writeln('Digite sua senha: '),
    read(Senha),
    menuUsuario(Login).
  
cadastroTerminal :-
    writeln('Digite o nome de usuário que deseja utilizar: '),
    read(Login),
    writeln('Digite a senha: '),
    read(Senha),
    addUsuario(Login, Senha),
    menuInicial().

menuUsuario(Login) :-
    writeln("\n1 - Criar um novo tweet"),
    writeln("2 - Ver seus tweets"),
    writeln("3 - Deletar Tweet"),
    writeln("4 - Ver quem voce segue"),
    writeln("5 - Ver timeline"),
    writeln("6 - Seguir alguem"),
    writeln("7 - Ver minhas curtidas"),
    writeln("8 - Deslogar\n"),
    read(Option),
    (
        Option =:= 1 -> criarTweet(Login);
        Option =:= 2 -> verTweets(Login);
        Option =:= 3 -> deletarTweet(Login);
        Option =:= 4 -> verSeguindo(Login);
        Option =:= 5 -> verTimeline(Login);
        Option =:= 6 -> seguir(Login);
        Option =:= 7 -> verCurtidas(Login);
        Option =:= 8 -> menuInicial();
        writeln('Opção invalida!'), nl,
        menuUsuario(Login)
    ).

criarTweet(Login) :-
    writeln('Digite o texto do tweet: '), nl,
    read(Texto),
    addTweet(Login, Texto),
    writeln('Tweet publicado!'),
    writeln('Pressione qualquer tecla para voltar ao menu inicial.'),
    read(Aux),
    menuUsuario(Login).


verTweets(Login) :- 
    writeln('Tweets:'),
    atom_string(Login, LoginString),
    exibirMeusTweets(LoginString),
    writeln('Pressione qualquer tecla para voltar ao menu inicial.'),
    read(Aux),
    menuUsuario(Login).

verTimeline(Login) :- 
    writeln('Timeline: '),
    atom_string(Login, LoginString),
    exibirMinhaTimeLine(LoginString),
    writeln('Digite o ID do tweet que deseja acessar: '),
    read(IDTweet),
    acessarTweetTimeline(Login, IDTweet),
    menuUsuario(Login).

acessarTweetTimeline(Login, IDTweet) :-
    cls(),
    atom_string(IDTweet, IDTweetString),
    exibirTweetComRespostas(IDTweetString),
    writeln('1 - Curtir     2 - Responder       3 - Voltar'),
    read(Option),
    (
        Option =:= 1 -> curtirTweet(Login, IDTweetString);
        Option =:= 2 -> responderTweet(Login, IDTweetString);
        Option =:= 3 -> menuUsuario(Login);
        writeln('Opção invalida!'), nl,
        menuUsuario(Login)
    ).

verCurtidas(Login) :-
    writeln('\nCurtidas: '),
    atom_string(Login, LoginString),
    exibirMinhasCurtidas(LoginString),
    writeln('\nPressione qualquer tecla para voltar ao menu inicial.\n'),
    read(Aux),
    menuUsuario(Login).

curtirTweet(Login, IDTweet) :-
    addCurtida(IDTweet, Login),
    cls(),
    exibirTweetComRespostas(IDTweet).

responderTweet(Login, IDTweet) :-
    writeln('\nDigite o texto da resposta: '),
    read(Texto),
    addResposta(Login, Texto, IDTweet),
    cls(),
    exibirTweetComRespostas(IDTweet).

seguir(Login) :-
    cls(),
    writeln('Digite o nome de usuário que deseja seguir: '),
    read(Amigo),
    addSeguidor(Login, Amigo),
    writeln('Seguindo!'),
    menuUsuario(Login).

verSeguindo(Login) :-
    writeln('\n'),
    atom_string(Login, LoginString),
    showUsuario(LoginString),
    writeln('Pressione qualquer tecla para voltar ao menu inicial.'),
    read(Aux),
    menuUsuario(Login).

deletarTweet(Login) :-
    writeln('\nDigite o ID do tweet que deseja deletar: '),
    read(IDTweet),
    atom_string(IDTweet, IDTweetString),
    removerTweet(IDTweetString),
    writeln('Tweet deletado!'),
    menuUsuario(Login).