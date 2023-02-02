:- use_module(library(http/json)).

addUsuario(Login, Senha) :-
    readJSON('database/usuarios.json', File),
    usuariosToJSON(File, ListaUsuariosJSON),
    usuarioToJSON(Login, Senha, "", "", UsuarioJSON),
    append(ListaUsuariosJSON, [UsuarioJSON], Saida),
    open('database/usuarios.json', write, Stream), write(Stream, Saida), close(Stream).

usuariosToJSON([], []).
usuariosToJSON([H|T], [X|Out]) :- 
    usuariosToJSON(H.login, H.senha, X),
    usuariosToJSON(T, Out).

usuarioToJSON(Login, Senha, Seguindo, Curtidas, Out) :-
    swritef(Out, '{"login": "%w", "senha": "%w", "seguindo": "%w", "curtidas": "%w"}', [Login, Senha, Seguindo, Curtidas]).

showUsuarios() :-
    readJSON("usuarios", Result),
    showUsuariosAux(Result).

% ! acho que essa funcao sera usada apenas internamente para consultas
showUsuariosAux([]) :- !.
showUsuariosAux([H|T]) :-
    write(H.login), write(" - "), write(H.senha), nl,
    showUsuariosAux(T).

readJSON(NomeArquivo, File) :-
    open(FilePath, read, F),
    (at_end_of_stream(F) -> File = []; json_read_dict(F, File)).

showRecursively([]).
showRecursively([Row|[]]) :- write(Row), nl.
showRecursively([Row|Rows]) :- write(Row), nl, showRecursively(Rows).

checaExistencia(NomeArquivo, Login) :-
    readJSON(NomeArquivo, File),
    atom_string(Login, LoginString),
    getObjetoRecursivamente(File, LoginString, Result),
    Result \= "".

addCurtida([], _, _, []).
addCurtida([H|T], H.login, IdCurtido, [_{login:H.login, senha:H.senha, seguindo:H.seguindo, curtidas: Y}|T]) :- 
    atom_concat(IdCurtido, " ", W), atom_concat(H.curtidas, W, Y).
addCurtida([H|T], Login, IdCurtido, [H|Out]) :- 
	addCurtidaJSON(T, Login, IdCurtido, Out).

addCurtidaUsuario(Login, IdCurtido) :-
    readJSON('database/usuarios.json', File),
    addCurtida(File, Login, IdCurtido, SaidaParcial),
    usuariosToJSON(SaidaParcial, Saida),
    open('database/usuarios.json', write, Stream), write(Stream, Saida), close(Stream).

getUsuario([], _, []).
getUsuario([H|_], H.login, H).
getUsuario([_|T], Login, Out) :- 
    getUsuario(T, Login, Out).

listaCurtidas(Login, L) :-
    readJSON('database/usuarios.json', File),
    getUsuario(File, Login, Out),
    split_string(Out.curtidas, "\s", "\s", L).