

module Services.TweetService where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Data.Time.Clock

criarTweetService :: Connection -> String -> String -> IO ()
criarTweetService conn login conteudo = do
    time <- getCurrentTime
    criarTweet conn login conteudo time False
    return ()