{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant id" #-}
{-# HLINT ignore "Eta reduce" #-}
module Models.Tweet where
    import Database.PostgreSQL.Simple
    import Database.PostgreSQL.Simple.FromRow (field)
    import qualified Database.PostgreSQL.Simple.FromRow as Database.PostgreSQL.Simple.Internal
    data Tweet = Tweet {
        idUsuario:: String,        
		idTweet:: Int,
        conteudo:: String,
        curtidas:: Int,
        timeStamp:: Int,
        isResposta:: Bool,
        nRespostas:: Int
    } deriving (Show, Read)
    
    instance FromRow Tweet where
    fromRow = Tweet <$> field
                    <*> field
                    <*> field
                    <*> field
                    <*> field
                    <*> field
                    <*> field

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
