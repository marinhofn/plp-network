:- use_module(library(http/json)).

addUsuario(Login, Senha) :-
    NomeArquivo = "usuarios",
    readJSON(NomeArquivo, File),
    usuarioToJSON(File, ListaObjectsJSON),
    append(ListaObjectsJSON, [ObjectJSON], Saida),
    getFilePath(NomeArquivo, FilePath),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

usuariosToJSON([], []).
usuariosToJSON([H|T], [X|Out]) :- 
    usuariosToJSON(H.login, H.senha, X),
    usuariosToJSON(T, Out).

usuarioToJSON(Login, Senha, Out) :-
    swritef(Out, '{"login": "%w", "senha": "%w"}', [Login, Senha]).

showUsuarios() :-
    readJSON("usuarios", Result),
    showUsuariosAux(Result).

% ! acho que essa funcao sera usada apenas internamente para consultas
showUsuariosAux([]) :- !.
showUsuariosAux([H|T]) :-
    write(H.login), write(" - "), write(H.senha), nl,
    showUsuariosAux(T).

readJSON(NomeArquivo, File) :-
    getFilePath(NomeArquivo, FilePath),
    open(FilePath, read, F),
    (at_end_of_stream(F) -> File = []; json_read_dict(F, File)).

getFilePath(NomeArquivo, FilePath) :-
    atom_concat("database/", NomeArquivo, S),
    atom_concat(S, ".json", FilePath).

showRecursively([]).
showRecursively([Row|[]]) :- write(Row), nl.
showRecursively([Row|Rows]) :- write(Row), nl, showRecursively(Rows).

checaExistencia(NomeArquivo, Login) :-
    readJSON(NomeArquivo, File),
    atom_string(Login, LoginString),
    getObjetoRecursivamente(File, LoginString, Result),
    Result \= "".