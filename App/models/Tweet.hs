module Models.Tweet where
    data Tweet = Tweet {
        idUsuario:: String,        
		id:: Int,
        conteudo:: String,
        curtidas:: Int,
        timeStamp:: Int,
        isResposta:: Bool,
        respostas:: [(String,Int)]
    } deriving (Show, Read)

    getidUsuario:: Tweet -> String
    getidUsuario a = idUsuario a

    getId:: Tweet -> String
    getId a = id a

    getTweet:: Tweet -> String
    getTweet a = conteudo a

    getCurtidas:: Tweet -> Int
    getCurtidas a = curtidas a

    getRepostas:: Tweet -> [Tweet]
    getRepostas a = respostas a

    editTweet:: Tweet -> String -> Tweet
    editTweet a b = Tweet { (getidUsuario a) (getid a) b (getCurtidas a) (getRepostas a)}

    exibeTweet:: Tweet -> IO()
    exibeTweet a = do
        putStrLn getidUsuario a
        putStrLn getTweet a
        putStrLn "Curtidas: " ++ show getCurtidas a
        putStrLn "Respostas:"
        respostas <- getRepostas a
        map exibeTweet respostas
        putStrLn "--------"
