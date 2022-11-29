module Services.TweetService where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Data.Time.Clock
import Data.Time.Clock.POSIX
import Data.Int
import Models.Tweet

-- criarTweetService :: Connection -> String -> String -> IO ()
-- criarTweetService conn login conteudo = do
--     time <- getCurrentTime
--     criarTweet conn login conteudo time False
--     return ()

-- criarRespostaService :: String -> Connection -> String -> UTCTime -> IO () 
-- criarTweetService login conn conteudo time = do
--     criarTweet conn login conteudo (timeInt time) False
--     return ()

criarTweetService :: String -> Connection -> String -> UTCTime -> IO () 
criarTweetService login conn conteudo time = do
    criarTweet conn login conteudo (timeInt time) False
    return ()

mostrarTweets:: [Tweet] -> IO()
mostrarTweets [] = putStrLn ""
mostrarTweets (x:xs) = do
    exibeTweet x
    mostrarTweets xs

timeInt :: UTCTime -> Int
timeInt = floor . (1e9 *) . nominalDiffTimeToSeconds . utcTimeToPOSIXSeconds

getTimeLine :: Connection -> String -> IO [Tweet]
getTimeLine conn login = do
    tweets <- getTweetsTimeLine conn login
    return tweets

getTweetService :: Connection -> Int -> IO Tweet
getTweetService conn id = do
    tweet <- getTweetRepository conn id
    return tweet
