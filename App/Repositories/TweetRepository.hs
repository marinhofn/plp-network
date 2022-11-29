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


getRespostas:: Connection ->  String -> IO [Tweet]
getRespostas conn idTweet= do
    let q = "select Tweets.id, \
                \Tweets.idTweet, \
                \Tweets.conteudo, \
                \Tweets.curtidas, \
                \Tweets.timeStamp, \
                \Tweets.isResposta, \
                \Tweets.nRespostas \
                \from Tweets INNER JOIN RespostasTweet \
                \on Tweets.idTweet = RespostasTweet.idTweetResposta \
                \where RespostasTweet.idTweetPrincipal = ?\
                \order by timeStamp desc"        
    query conn q [idTweet]:: IO [Tweet]

getLastTweet:: Connection -> String -> IO [Tweet]
getLastTweet conn user = do
    let q = "select Tweets.id, \
                \Tweets.idTweet, \
                \Tweets.conteudo, \
                \Tweets.curtidas, \
                \Tweets.timeStamp, \
                \Tweets.isResposta, \
                \Tweets.nRespostas \
                \from Tweets \
                \where id = ?\
                \order by timeStamp desc \
                \limit 5"        
    query conn q [user]:: IO [Tweet]

getTweetRepository :: Connection -> Int -> Tweet
getTweetRepository conn idTweet = do
    let q = "select * from Tweets where idTweet = ?"
    query conn q [idTweet]:: IO [Tweet]