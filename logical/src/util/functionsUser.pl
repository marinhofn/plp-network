:- module(functionsUser, [addUsuario/2, addCurtidaUsuario/2, addSeguidor/2, listaSeguidores/2, showUsuario/1, removerSeguidor/2, listaCurtidas/2]).
:- use_module(library(http/json)).
    
addUsuario(Login, Senha) :-
    readJSON('util/database/usuarios.json', File),
    usuariosToJSON(File, ListaUsuariosJSON),
    usuarioToJSON(Login, Senha, "", "", UsuarioJSON),
    append(ListaUsuariosJSON, [UsuarioJSON], Saida),
    open('util/database/usuarios.json', write, Stream), write(Stream, Saida), close(Stream).

usuariosToJSON([], []).
usuariosToJSON([H|T], [X|Out]) :- 
    usuarioToJSON(H.login, H.senha, H.seguindo, H.curtidas, X),
    usuariosToJSON(T, Out).

usuarioToJSON(Login, Senha, Seguindo, Curtidas, Out) :-
    swritef(Out, '{"login": "%w", "senha": "%w", "seguindo": "%w", "curtidas": "%w"}', [Login, Senha, Seguindo, Curtidas]).

showUsuarios() :-
    readJSON('util/database/usuarios.json', Result),
    showUsuariosAux(Result).

% ! acho que essa funcao sera usada apenas internamente para consultas
showUsuariosAux([]) :- !.
showUsuariosAux([H|T]) :-
    write(H.login), write(" - "), write(H.senha), nl,
    showUsuariosAux(T).

readJSON(FilePath, File) :-
    open(FilePath, read, F),
    (at_end_of_stream(F) -> File = []; json_read_dict(F, File)).

showRecursively([]).
showRecursively([Row|[]]) :- write(Row), nl.
showRecursively([Row|Rows]) :- write(Row), nl, showRecursively(Rows).

checaExistencia(Login) :-
    readJSON('util/database/usuarios.json', File),
    atom_string(Login, LoginString),
    getObjetoRecursivamente(File, LoginString, Result),
    Result \= "".

addCurtida([], _, _, []).
addCurtida([H|T], H.login, IdCurtido, [_{login:H.login, senha:H.senha, seguindo:H.seguindo, curtidas: Y}|T]) :- 
    atom_concat(IdCurtido, " ", W), atom_concat(H.curtidas, W, Y).
addCurtida([H|T], Login, IdCurtido, [H|Out]) :- 
	addCurtida(T, Login, IdCurtido, Out).

addCurtidaUsuario(Login, IdCurtido) :-
    readJSON('util/database/usuarios.json', File),
    atom_string(Login, LoginString),
    atom_string(IdCurtido, IdCurtidoString),
    addCurtida(File, LoginString, IdCurtidoString, SaidaParcial),
    usuariosToJSON(SaidaParcial, Saida),
    open('util/database/usuarios.json', write, Stream), write(Stream, Saida), close(Stream).

getUsuario([], _, []).
getUsuario([H|_], H.login, H).
getUsuario([_|T], Login, Out) :- 
    getUsuario(T, Login, Out).

listaCurtidas(Login, L) :-
    readJSON('util/database/usuarios.json', File),
    getUsuario(File, Login, Out),
    split_string(Out.curtidas, "\s", "\s", L).


addSeguidor([], _, _, []).
addSeguidor([H|T], H.login, IdSeguido, [_{login:H.login, senha:H.senha, seguindo:Y, curtidas: H.curtidas}|T]) :- 
    atom_concat(IdSeguido, " ", W), atom_concat(H.seguindo, W, Y).
addSeguidor([H|T], Login, IdCurtido, [H|Out]) :- 
	addSeguidor(T, Login, IdCurtido, Out).

addSeguidor(Login, IdSeguido) :-
    readJSON('util/database/usuarios.json', File),
    atom_string(Login, LoginString),
    atom_string(IdSeguido, IdSeguidoString),
    addSeguidor(File, LoginString, IdSeguidoString, SaidaParcial),
    usuariosToJSON(SaidaParcial, Saida),
    open('util/database/usuarios.json', write, Stream),
    write(Stream, Saida), close(Stream).

removerSeguidor(Login, Remover) :-
    readJSON('util/database/usuarios.json', File),
    getUsuario(File, Login, Out),
    split_string(Out.seguindo, "\s", "\s", L),
    delete(L, Remover, Seguindo),
    atomic_list_concat(Seguindo, ' ', Atom),
    removeSeguidor(File, Login, Atom, SaidaParcial),
    usuariosToJSON(SaidaParcial, Saida),
    open('util/database/usuarios.json', write, Stream), write(Stream, Saida), close(Stream).

removeSeguidor([], _, _, []).
removeSeguidor([H|T], H.login, NovosSeguidores, [_{login:H.login, senha:H.senha, seguindo:NovosSeguidores, curtidas: H.curtidas}|T]).
removeSeguidor([H|T], Login, NovosSeguidores, [H|Out]) :- 
	removeSeguidor(T, Login, NovosSeguidores, Out).


listaSeguidores(Login, L) :-
    readJSON('util/database/usuarios.json', File),
    getUsuario(File, Login, Out),
    split_string(Out.seguindo, "\s", "\s", L).



showUsuario(Login) :-
    readJSON('util/database/usuarios.json', File),
    getUsuario(File, Login, Out),
    write("Usuario: "), write(Out.login), nl,
    write("Ele(a) segue: "), nl,
    split_string(Out.seguindo, "\s", "\s", L),
    showUsuarioAux(L).

% acho que essa funcao sera usada apenas internamente para consultas
showUsuarioAux([]) :- !.
showUsuarioAux([H|T]) :-
    write(H), nl,
    showUsuarioAux(T).

