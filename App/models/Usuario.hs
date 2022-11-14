module Models.Usuario where
    import Models.Tweet
    data Usuario = Usuario {
        idUsuario:: String, --nome do usuario        
		senha:: String,
        meusTweets:: [(String,Int)], --(idCliente,idTweet)
        paginaInicial:: [(String,Int)] --(idCliente,idTweet)
        curtidas:: [(String,Int)], --(idCliente,idTweet)
        seguindo:: [String], --(idCliente)
        seguidores:: [String] --(idCliente)
        numeroDeTweets:: Int
    } deriving (Show, Read)