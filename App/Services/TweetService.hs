module Services.TweetService where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Repositories.RespostaRepository
import Data.Time.Clock
import Data.Time.Clock.POSIX
import Data.Int
import Models.Tweet
import Control.Exception

criarTweetService :: String -> Connection -> String -> UTCTime -> IO () 
criarTweetService login conn conteudo time = criarTweet conn login conteudo (timeInt time) False

deleteTweet:: Connection -> String -> Int -> IO () 
deleteTweet conn login idTweet = do  
    tweets <- getTweet conn idTweet
    let tweet = head tweets
    if (isResposta tweet) then do 
        tweetPrincipais <- getTweetPrincipal conn idTweet
        let tweetPrincipal = head tweetPrincipais
        removerNumeroResposta conn (getidUsuario tweetPrincipal) (getId tweetPrincipal)
        deletarTweet conn login idTweet
    else deletarTweet conn login idTweet

deleteTweetService:: Connection -> String -> Int -> IO ()
deleteTweetService conn login idTweet = do
    {catch (deleteTweet conn login idTweet) handler;}
    where
        handler :: SqlError -> IO ()
        handler e = do
            putStrLn "Tweet desejado não existe ou não lhe pertence!"
            putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
            aux <- getLine
            return ()

mostrarTweets:: [Tweet] -> IO()
mostrarTweets [] = putStrLn ""
mostrarTweets (x:xs) = do
    exibeTweet x
    mostrarTweets xs

editTweet:: Connection -> String -> Int -> String -> IO ()
editTweet conn idUsuario idTweet conteudo = editarTweet conn idUsuario idTweet conteudo

updateTweetService:: Connection -> String -> Int -> String -> IO ()
updateTweetService conn idUsuario idTweet conteudo = do
    {catch (editarTweet conn idUsuario idTweet conteudo) handler;}
    where
        handler :: SqlError -> IO ()
        handler e = do
            putStrLn "Tweet desejado não existe ou não lhe pertence!"
            putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
            aux <- getLine
            return ()

getTweetsUsuarioService:: Connection -> String -> IO [Tweet]
getTweetsUsuarioService conn login = getTweetsUsuario conn login

getTimeLineService:: Connection -> String -> IO [Tweet]
getTimeLineService conn login = getTweetsTimeLine conn login

timeInt :: UTCTime -> Int
timeInt = floor . (1e9 *) . nominalDiffTimeToSeconds . utcTimeToPOSIXSeconds

getTimeLine :: Connection -> String -> IO [Tweet]
getTimeLine conn login = do
    tweets <- getTweetsTimeLine conn login
    return tweets

getTweetService :: Connection -> Int -> IO Tweet
getTweetService conn id = do
    tweet <- getTweet conn id
    return (head tweet)
