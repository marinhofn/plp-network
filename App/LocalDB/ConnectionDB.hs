{-# LANGUAGE OverloadedStrings #-}
module LocalDB.ConnectionDB where
import Database.PostgreSQL.Simple

localDB:: ConnectInfo
localDB = defaultConnectInfo {
    connectHost = "localhost",
    connectDatabase = "ARedeSocial",
    connectUser = "postgres",
    connectPassword = "741258963",
    connectPort = 5432
}

iniciandoDatabase :: IO Connection
iniciandoDatabase = do
    c <- connectionMyDB
	createUsers c
    createTweets c 
    createRespostas c
    createCurtidas c
    createSeguidores c
    return c

connectionMyDB :: IO Connection
connectionMyDB = connect localDB


createUsers :: Connection -> IO()
createUsers conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS usuarios(\
                    \id VARCHAR(15) NOT NULL UNIQUE,\
                    \senha VARCHAR(15) NOT NULL,\
                    \numeroTweets INT DEFAULT 0,\
                    \CONSTRAINT pk_usuarios PRIMARY KEY(id));"
    return()


createTweets :: Connection -> IO()
createTweets conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS tweets(\
                    \id VARCHAR(15) NOT NULL,\
                    \idTweet INT NOT NULL,\
                    \conteudo VARCHAR(150) NOT NULL,\
                    \curtidas INT DEFAULT 0,\
                    \timeStamp INT NOT NULL,\
                    \isResposta BOOLEAN NOT NULL,\
                    \CONSTRAINT fk_usuarios FOREIGN KEY (id) REFERENCES Usuarios(id) ON DELETE CASCADE,\
                    \CONSTRAINT pk_tweets PRIMARY KEY (id, idTweet));"
    return()


createRespostas :: Connection -> IO()
createRespostas conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS respostasTweet(\
                    \idPrincipal VARCHAR(15) NOT NULL,\
                    \idTweetPrincipal INT NOT NULL,\
                    \idResposta VARCHAR(15) NOT NULL,\
                    \idTweetResposta INT NOT NULL,\
                    \CONSTRAINT pk_respostas PRIMARY KEY (idPrincipal, idTweetPrincipal),\
                    \CONSTRAINT fk_tweets1 FOREIGN KEY (idPrincipal, idTweetPrincipal) REFERENCES tweets(id, idTweet) ON DELETE CASCADE,\
                    \CONSTRAINT fk_tweets2 FOREIGN KEY (idResposta, idTweetResposta) REFERENCES tweets(id, idTweet) ON DELETE CASCADE);"
    return()

createCurtidas :: Connection -> IO()
createCurtidas conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS curtidas(\
                    \id VARCHAR(15) NOT NULL,\
                    \idCurtido VARCHAR(15) NOT NULL,\
                    \idTweetCurtido INT NOT NULL,\
                    \CONSTRAINT pk_curtidas PRIMARY KEY (id),\
                    \CONSTRAINT fk_usuario FOREIGN KEY (id) REFERENCES usuarios(id) ON DELETE CASCADE,\
                    \CONSTRAINT fk_tweets FOREIGN KEY (idCurtido, idTweetCurtido) REFERENCES tweets(id, idTweet) ON DELETE CASCADE);"
    return()

createSeguidores :: Connection -> IO()
createSeguidores conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS seguidores(\
                    \id VARCHAR(15) NOT NULL,\
                    \idSeguido VARCHAR(15) NOT NULL,\
                    \CONSTRAINT fk_usuario1 FOREIGN KEY (id) REFERENCES usuarios(id) ON DELETE CASCADE,\
                    \CONSTRAINT fk_usuario2 FOREIGN KEY (idSeguido) REFERENCES usuarios(id) ON DELETE CASCADE);"
    return()