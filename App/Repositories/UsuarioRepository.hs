{-# LANGUAGE OverloadedStrings #-}
module Repositories.UsuarioRepository where
import Database.PostgreSQL.Simple

cadastrarUsuario:: Connection -> String -> String -> IO ()
cadastrarUsuario conn nome senha  = do
    let q = "insert into usuarios (id, senha) values (?,?)"
    execute conn q (nome, senha)
    return ()

seguirAmigo:: Connection -> String -> String -> IO ()
seguirAmigo conn nome1 nome2 = do
    let q = "insert into seguidores (id, idSeguido) values (?,?)"
    execute conn q (nome1, nome2)
    return ()

abandonarAmigo:: Connection -> String -> String -> IO ()
abandonarAmigo conn nome1 nome2 = do
    let q = "delete from seguidores where id=? and idSeguido=?"
    execute conn q (nome1, nome2)
    return ()

validarUsuario :: Connection -> String -> IO String
validarUsuario conn login = do
    let q = "select id from usuarios where id=?"
    [Only nome] <- query conn q (Only login)
    return nome

validarSenha :: Connection -> String -> IO String
validarSenha conn login = do
    let q = "select senha from usuarios where id=?"
    [Only senha] <- query conn q (Only login)
    return senha