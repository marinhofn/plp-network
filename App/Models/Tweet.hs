{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Models.Tweet where
    import GHC.Generics (Generic)
    import Database.PostgreSQL.Simple (FromRow)
    import Data.Time.Clock.POSIX
    import Data.Time.Clock

    data Tweet = Tweet {
        idUsuario:: String,
		idTweet:: Int,
        conteudo:: String,
        curtidas:: Int,
        timeStamp:: Integer,
        isResposta:: Bool,
        nRespostas:: Int
    } deriving (Show, Read, Generic, FromRow)
    
    getidUsuario:: Tweet -> String
    getidUsuario t = idUsuario t

    getId:: Tweet -> Int
    getId t = idTweet t

    getTweet:: Tweet -> String
    getTweet t = conteudo t

    getCurtidas:: Tweet -> Int
    getCurtidas t = curtidas t

    getNumRespostas:: Tweet -> Int
    getNumRespostas t = nRespostas t

    getTimeStamp:: Tweet -> Integer
    getTimeStamp t = timeStamp t

    getTimeStampUTC :: Tweet -> UTCTime
    getTimeStampUTC t = posixSecondsToUTCTime (fromInteger (getTimeStamp t))

    exibeTweet:: Tweet -> IO()
    exibeTweet t = do
        putStrLn $ "    |   " ++ getidUsuario t ++ " -> " ++ show (getId t) ++ "\n    |   "
        putStrLn $ "    |   " ++ getTweet t ++ "\n    |   "
        --putStrLn $ show (getTimeStampUTC t) ++ show (getTimeStamp t)        
        putStrLn $ "    |   Curtidas:   " ++ show (getCurtidas t)
        putStrLn $ "    |   Respostas:  " ++ show (getNumRespostas t)
        putStrLn "\n"

