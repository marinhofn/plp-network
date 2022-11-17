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

getTweets:: Connection -> IO [Tweet]
getTweets conn = do
    query_ conn "SELECT i.id,\
                       \i.idTweet,\
                       \i.conteudo,\
                       \i.curtidas,\
                       \i.timestamp, \
                       \i.isResposta,\
                       \i.nRespostas \
                       \FROM tweet i":: IO [Tweet]