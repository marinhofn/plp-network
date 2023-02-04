{-# LANGUAGE OverloadedStrings #-}
module Repositories.CurtidaRepository where
import Database.PostgreSQL.Simple
import Models.Tweet

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

diminuiNumeroCurtida:: Connection -> String -> Int -> IO ()
diminuiNumeroCurtida conn id idTweet  = do
    let q = "update Tweets set curtidas = curtidas - 1 where id=? and idTweet=?"
    execute conn q (id, idTweet)
    return ()

removeCurtida:: Connection -> String -> Int -> IO ()
removeCurtida conn idUsuario idTweet = do
    let q = "delete from curtidas where idCurtido=? and idTweetCurtido=?"
    execute conn q (idUsuario, idTweet)
    return ()

getTweetsCurtidos:: Connection -> String -> IO [Tweet]
getTweetsCurtidos conn id = do
    let q = "select Tweets.id, \
                \Tweets.idTweet, \
                \Tweets.conteudo, \
                \Tweets.curtidas, \
                \Tweets.timeStamp, \
                \Tweets.isResposta, \
                \Tweets.nRespostas \
                \from Tweets INNER JOIN Curtidas \
                \on Tweets.idTweet = Curtidas.idTweetCurtido \
                \where Curtidas.id = ?\
                \order by timeStamp desc"          
    query conn q [id]:: IO [Tweet]