{-# LANGUAGE OverloadedStrings #-}
module Repositories.TweetRepository where
import Database.PostgreSQL.Simple
import Models.Tweet
import Data.Time.Clock

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

getTweet:: Connection -> Int -> IO [Tweet]
getTweet conn idTweet = do
    let q = "select Tweets.id, \
                \Tweets.idTweet, \
                \Tweets.conteudo, \
                \Tweets.curtidas, \
                \Tweets.timeStamp, \
                \Tweets.isResposta, \
                \Tweets.nRespostas \
                \from Tweets \ 
                \where idTweet = ?"
    query conn q [idTweet]:: IO [Tweet]

getTweetsUsuario:: Connection -> String -> IO [Tweet]
getTweetsUsuario conn id = do
    let q = "select Tweets.id, \
                \Tweets.idTweet, \
                \Tweets.conteudo, \
                \Tweets.curtidas, \
                \Tweets.timeStamp, \
                \Tweets.isResposta, \
                \Tweets.nRespostas \
                \from Tweets \
                \where Tweets.id = ?\
                \order by timeStamp desc"          
    query conn q [id]:: IO [Tweet]

getTweetsTimeLine:: Connection -> String -> IO [Tweet]
getTweetsTimeLine conn id = do
    let q = "select Tweets.id, \
                \Tweets.idTweet, \
                \Tweets.conteudo, \
                \Tweets.curtidas, \
                \Tweets.timeStamp, \
                \Tweets.isResposta, \
                \Tweets.nRespostas \
                \from Tweets INNER JOIN Seguidores \
                \on Tweets.id = Seguidores.idSeguido \
                \where Seguidores.id = ?\
                \order by timeStamp desc"        
    query conn q [id]:: IO [Tweet]