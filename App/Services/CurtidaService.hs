module Services.CurtidaService where
import Database.PostgreSQL.Simple
import Repositories.CurtidaRepository
import Models.Tweet
import Repositories.TweetRepository

addCurtida:: Connection -> String -> Int -> IO () 
addCurtida conn id idTweetCurtido = do 
    aaa <- (getTweet conn idTweetCurtido):: IO [Tweet]
    let tweet = head aaa
    adicionarNumeroCurtida conn (getidUsuario tweet) idTweetCurtido
    adicionarCurtida conn id (getidUsuario tweet) idTweetCurtido

removeCurtidaService:: Connection -> String -> Int -> IO () 
removeCurtidaService conn id idTweetCurtido = do
    tweeet <- getTweet conn idTweetCurtido
    let tweet = head tweeet
    diminuiNumeroCurtida conn (getidUsuario tweet) idTweetCurtido
    removeCurtida conn (getidUsuario tweet) idTweetCurtido