{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Models.Tweet where
    import GHC.Generics (Generic)
    import Database.PostgreSQL.Simple (FromRow)
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
    getidUsuario a = idUsuario a

    getId:: Tweet -> Int
    getId a = idTweet a

    getTweet:: Tweet -> String
    getTweet a = conteudo a

    getCurtidas:: Tweet -> Int
    getCurtidas a = curtidas a

    getNumRespostas:: Tweet -> Int
    getNumRespostas a = nRespostas a

    exibeTweet:: Tweet -> IO()
    exibeTweet a = do
        putStrLn $ getidUsuario a
        putStrLn $ getTweet a
        putStrLn $ "Curtidas: " ++ show (getCurtidas a)
        putStrLn $ "Respostas:" ++ show (getNumRespostas a)
        putStrLn "--------"
