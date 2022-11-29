-- TODO

module Services.TweetService where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Data.Time.Clock
import Data.Time.Clock.POSIX
import Data.Int

-- criarTweetService :: Connection -> String -> String -> IO ()
-- criarTweetService conn login conteudo = do
--     time <- getCurrentTime
--     criarTweet conn login conteudo time False
--     return ()

criarTweetService :: String -> Connection -> String -> UTCTime -> IO () 
criarTweetService login conn conteudo time = do
    criarTweet conn login conteudo (timeInt time) False
    return ()


timeInt :: UTCTime -> Int
timeInt = floor . (1e9 *) . nominalDiffTimeToSeconds . utcTimeToPOSIXSeconds