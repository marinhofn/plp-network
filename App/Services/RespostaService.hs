module Services.RespostaService where
import Database.PostgreSQL.Simple
import Models.Tweet
import Repositories.TweetRepository
import Repositories.RespostaRepository
import Data.Time.Clock
import Data.Time.Clock.POSIX
import Services.TweetService

addResponseService:: Connection -> String -> String -> UTCTime -> Int -> IO () 
addResponseService conn id conteudo time idTweet = do
    criarTweet conn id conteudo (timeInt time) True
    tweeet <- getLastTweet conn id
    let tweet = head tweeet
    tweetOriginais <- getTweet conn idTweet
    let tweetOriginal = head tweetOriginais
    adicionarNumeroResposta conn (getidUsuario tweetOriginal)  (getId tweetOriginal)
    adicionarResposta conn (getidUsuario tweetOriginal) (getId tweetOriginal) (getidUsuario tweet) (getId tweet)

getTweetWithResponsesService:: Connection ->  Int -> IO [Tweet]
getTweetWithResponsesService conn idTweet = do
    tweet <- getTweet conn idTweet
    tweets <- getRespostas conn idTweet
    return(tweet ++ tweets)

-- timeInt :: UTCTime -> Int
-- timeInt = floor . (1e9 *) . nominalDiffTimeToSeconds . utcTimeToPOSIXSeconds

validacao:: Connection -> Int -> IO Bool
validacao conn idTweet = do
    tweets <- getTweet conn idTweet
    return ((length tweets) /= 0)