{-# LANGUAGE OverloadedStrings #-}
module Repositories.UsuarioRepository where
import Database.PostgreSQL.Simple
import System.IO.Error
import Control.Exception
import Models.Usuario

cadastrarUsuario :: Connection -> String -> String -> IO ()
cadastrarUsuario conn nome senha  = do
    let q = "insert into usuarios (id, senha) values (?,?)"
    execute conn q (nome, senha)
    return ()

registerUser :: Connection -> String -> String -> IO ()
registerUser conn name password = do
    {catch (cadastrarUsuario conn name password) handler;}
    where
        handler :: SqlError -> IO ()
        handler e = do
            putStrLn "Usuário já cadastrado!"
            putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
            aux <- getLine
            return ()

seguirAmigo:: Connection -> String -> String -> IO ()
seguirAmigo conn nome1 nome2 = do
    let q = "insert into seguidores (id, idSeguido) values (?,?)"
    execute conn q (nome1, nome2)
    return ()

followFriend:: Connection -> String -> String -> IO ()
followFriend conn nome1 nome2 = do
    {catch (seguirAmigo conn nome1 nome2) handler;}
    where
        handler :: SqlError -> IO ()
        handler e = do
            putStrLn "Usuário inexistente!"
            putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
            aux <- getLine
            return ()


abandonarAmigo:: Connection -> String -> String -> IO ()
abandonarAmigo conn nome1 nome2 = do
    let q = "delete from seguidores where id=? and idSeguido=?"
    execute conn q (nome1, nome2)
    return ()

unfollowFriend:: Connection -> String -> String -> IO ()
unfollowFriend conn nome1 nome2 = do
    {catch (abandonarAmigo conn nome1 nome2) handler;}
    where
        handler :: SqlError -> IO ()
        handler e = do
            putStrLn "Usuário inexistente!"
            putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
            aux <- getLine
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

-- getSeguindo :: Connection -> String -> IO [String]
-- getSeguindo conn login = do
--     let q = "select idSeguido from seguidores where id=?"
--     query conn q [login]:: IO [String]

-- getSeguidores :: Connection -> String -> IO [Usuario]
-- getSeguidores conn login = do
--     let q = "select id \
--             \from seguidores INNER JOIN Usuarios \
--             \on seguidores.idSeguido = Usuarios.id \
--             \where seguidores.idSeguido=?"
--     query conn q [login]:: IO [Usuario]

getSeguindo :: Connection -> String -> IO [Usuario]
getSeguindo conn login = do
    let q = "select Usuarios.* \
            \from seguidores INNER JOIN Usuarios \
            \on seguidores.idSeguido = Usuarios.id \
            \where seguidores.id=?"
    query conn q [login]:: IO [Usuario]

getSeguidores :: Connection -> String -> IO [Usuario]
getSeguidores conn login = do
    let q = "select Usuarios.* \
            \from seguidores INNER JOIN Usuarios \
            \on seguidores.id = Usuarios.id \
            \where seguidores.idSeguido=?"
    query conn q [login]:: IO [Usuario]