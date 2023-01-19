{-# LANGUAGE OverloadedStrings #-}
module Repositories.RespostaRepository where
import Database.PostgreSQL.Simple
import Models.Tweet 

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

removerNumeroResposta:: Connection -> String -> Int -> IO ()
removerNumeroResposta conn id idTweet  = do
    let q = "update Tweets set nRespostas = nRespostas - 1 where id=? and idTweet=?"
    execute conn q (id, idTweet)
    return ()

getTweetPrincipal :: Connection -> Int -> IO [Tweet]
getTweetPrincipal conn idTweet = do
    let q = "select Tweets.id, \
                \Tweets.idTweet, \
                \Tweets.conteudo, \
                \Tweets.curtidas, \
                \Tweets.timeStamp, \
                \Tweets.isResposta, \
                \Tweets.nRespostas \
                \from Tweets INNER JOIN RespostasTweet \
                \on Tweets.idTweet = RespostasTweet.idTweetPrincipal \
                \where RespostasTweet.idTweetResposta = ?"
    result <- query conn q [idTweet]:: IO [Tweet]
    return(result)

getRespostas:: Connection ->  Int -> IO [Tweet]
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
                \limit 1"        
    query conn q [user]:: IO [Tweet]