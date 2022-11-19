{-# LANGUAGE OverloadedStrings #-}
module Repositories.TweetRepository where
import Database.PostgreSQL.Simple
import Models.Tweet

criarTweet:: Connection -> String -> String -> Int -> Bool -> IO ()
criarTweet conn idUsuario conteudo timeStamp isResposta  = do
    let q = "insert into tweets (id, conteudo, timeStamp, isResposta) values (?, ?, ?, ?)"
    execute conn q (idUsuario, conteudo, timeStamp, isResposta)
    return ()

deletarTweet:: Connection -> String -> Int -> IO ()
deletarTweet conn idUsuario idTweet = do
    let q = "delete from tweets where id=? and idTweet=?"
    execute conn q (idUsuario, idTweet)
    return ()

editarTweet:: Connection -> String -> Int -> String -> IO ()
editarTweet conn idUsuario idTweet conteudo = do
    let q = "update tweets set conteudo=? where id=? and idTweet=?"
    execute conn q (conteudo, idUsuario, idTweet)
    return ()

adicionarResposta:: Connection -> String -> Int -> String -> Int -> IO ()
adicionarResposta conn idPrincipal idTweetPrincipal idResposta idTweetResposta = do
    let q = "insert into respostasTweet (idPrincipal, idTweetPrincipal, idResposta, idTweetResposta) values (?, ?, ?, ?)"
    execute conn q (idPrincipal, idTweetPrincipal, idResposta, idTweetResposta)
    return ()

adicionarNumeroResposta:: Connection -> String -> Int -> IO ()
adicionarNumeroResposta conn id idTweet  = do
    let q = "update Tweets set nRespostas = nRespostas + 1 where id=? and idTweet=?"
    execute conn q (id, idTweet)
    return ()

adicionarCurtida:: Connection -> String -> String -> Int -> IO ()
adicionarCurtida conn id idCurtido idTweetCurtido = do
    let q = "insert into curtidas (id, idCurtido, idTweetCurtido) values (?, ?, ?)"
    execute conn q (id, idCurtido, idTweetCurtido)
    return ()

adicionarNumeroCurtida:: Connection -> String -> Int -> IO ()
adicionarNumeroCurtida conn id idTweet  = do
    let q = "update Tweets set curtidas = curtidas + 1 where id=? and idTweet=?"
    execute conn q (id, idTweet)
    return ()

getTweets:: Connection -> String -> IO [Tweet]
getTweets conn id = do
    let q = "select * from Tweets order by timeStamp desc"
    query_ conn q :: IO [Tweet]

    
    