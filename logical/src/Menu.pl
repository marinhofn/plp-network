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
    % writeln('Login: '),
    % read(Login),
    % writeln('Senha: '),
    % read(Senha).

cadastroTerminal :-
    writeln('Cadastro not implemented yet!').
    % writeln('Login: '),
    % read(Login),
    % writeln('Senha: '),
    % read(Senha).

menuLogin() :-
    writeln("\nMenu login working!").
