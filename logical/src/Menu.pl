:- module('Menu', [menuInicial/0]).

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
    writeln('Login not implemented yet!').
    writeln('Digite seu login: '),
    read(Login),
    writeln('Digite sua senha: '),
    read(Senha),
    validarLogin(Login, Senha).


% implementar validação de login
%validarLogin(Login, Senha) :-


    

cadastroTerminal :-
    writeln('Cadastro not implemented yet!').
    writeln('Digite o nome de usuário que deseja utilizar: '),
    read(Login),
    writeln('Digite a senha: '),
    read(Senha),
    criarUsuario(Login, Senha).

menuLogin() :-
    writeln("\nMenu   working!").


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
        Option =:= 8 -> menuInicial();
        writeln('Opção inválida!'), nl,
        menuUsuario(Login)
    ).
    
criarTweetMenu(Login) :-
    writeln('Digite o texto do tweet: '),
    read(Texto),
    criarTweetService(Login, Texto),
    writeln('Tweet publicado!'),
    writeln('Pressione qualquer tecla para voltar ao menu inicial.'),
    read(Aux),
    menuUsuario(Login).

verTweets(Login) :- 
    writeln('Tweets:'),
    verTweetsService(Login),
    writeln('Pressione qualquer tecla para voltar ao menu inicial.'),
    read(Aux),
    menuUsuario(Login).

verTimeline(Login) :- 
    writeln('Timeline: '),
    vertTimelineService(Login),
    writeln('Digite o ID do tweet que deseja acessar: '),
    read(IDTweet),
    acessarTweetTimeline(Login, IDTweet),
    menuUsuario(Login).

acessarTweetFromTimeline(Login, IDTweet) :-
    tweetComRespostas(IDTweet),
    writeln('1 - Curtir     2 - Responder       3 - Voltar'),
    read(Option),
    (
        Option =:= 1 -> curtirTweet(Login, IDTWeet);
        Option =:= 2 -> responderTweet(Login, IDTweet);
        Option =:= 3 -> menuUsuario(Login);
        writeln('Opção inválida!'), nl,
        menuUsuario(Login)
    ).

