
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
  
loginTerminal :-
    writeln('Digite seu login: '),
    read(Login),
    writeln('Digite sua senha: '),
    read(Senha),
    %validarLogin(Login, Senha),
    menuUsuario(Login).
  
cadastroTerminal :-
    writeln('Digite o nome de usuário que deseja utilizar: '),
    read(Login),
    writeln('Digite a senha: '),
    read(Senha),
    addUsuario(Login, Senha),
    menuInicial().

menuUsuario(Login) :-
    writeln("1 - Criar um novo tweet"),
    writeln("2 - Ver seus tweets"),
    writeln("3 - Ver seus seguidores"),
    writeln("4 - Ver quem você segue"),
    writeln("5 - Ver timeline"),
    writeln("6 - Seguir alguém"),
    writeln("7 - Ver minhas curtidas"),
    writeln("8 - Deslogar\n"),
    read(Option),
    (
        Option =:= 1 -> criarTweet(Login);
        Option =:= 2 -> verTweets(Login);
        Option =:= 3 -> verSeguidores(Login);
        Option =:= 4 -> verSeguindo(Login);
        Option =:= 5 -> verTimeline(Login);
        Option =:= 6 -> seguir(Login);
        Option =:= 7 -> verCurtidas(Login);
        Option =:= 8 -> loginTerminal();
        writeln('Opção inválida!'), nl,
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
    exibirMeusTweets(Login),
    writeln('Pressione qualquer tecla para voltar ao menu inicial.'),
    read(Aux),
    menuUsuario(Login).

verTimeline(Login) :- 
    writeln('Timeline: '),
    exibirMinhaTimeLine(Login),
    writeln('Digite o ID do tweet que deseja acessar: '),
    read(IDTweet),
    acessarTweetTimeline(Login, IDTweet),
    menuUsuario(Login).

acessarTweetFromTimeline(Login, IDTweet) :-
    tweetComRespostas(IDTweet),
    writeln('1 - Curtir     2 - Responder       3 - Voltar'),
    read(Option),
    (
        Option =:= 1 -> curtirTweet(Login, IDTweet);
        Option =:= 2 -> responderTweet(Login, IDTweet);
        Option =:= 3 -> menuUsuario(Login);
        writeln('Opção inválida!'), nl,
        menuUsuario(Login)
    ).

verCurtidas(Login) :-
    writeln('\nCurtidas: '),
    exibirMinhasCurtidas(Login),
    writeln('\nPressione qualquer tecla para voltar ao menu inicial.\n'),
    read(Aux),
    menuUsuario(Login).

curtirTweet(Login, IDTweet) :-
    addCurtida(IDTweet, Login),
    writeln('\nTweet curtido!\n').

responderTweet(Login, IDTweet) :-
    writeln('\nDigite o texto da resposta: '),
    read(Texto),
    addResposta(Login, Texto, IDTweet),
    writeln('\nResposta publicada!\n').

seguir(Login) :-
    writeln('Digite o nome de usuário que deseja seguir: '),
    read(LoginAmigoString),
    addSeguidor(Login, LoginAmigoString),
    writeln('Seguindo!'),
    menuUsuario(Login).

verSeguidores(Login) :-
    writeln('Seguidores: '),
    listaSeguidores(Login),
    writeln('Pressione qualquer tecla para voltar ao menu inicial.'),
    read(Aux),
    menuUsuario(Login).