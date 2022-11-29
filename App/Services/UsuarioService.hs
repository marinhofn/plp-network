-- TODO
module Services.UsuarioService where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Models.Tweet

realizarCadastro :: Connection -> String -> String -> IO ()
realizarCadastro conn nome senha = do
    --cadastrarUsuario conn nome senha
    registerUser conn nome senha
    putStrLn "Cadastro efetuado com sucesso!"
    putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
    aux <- getLine
    return ()


getUsuario :: Connection -> String -> IO String
getUsuario conn login = do
    nome <- validarUsuario conn login
    return nome

getSenha :: Connection -> String -> IO String
getSenha conn login = do
    senha <- validarSenha conn login
    return senha

validarLogin :: Connection -> String -> String -> IO Bool
validarLogin conn login senha = do
    usuario <- getUsuario conn login
    usuarioSenha <- getSenha conn login
    if usuario == login && usuarioSenha == senha then do
        return True
    else do
        return False

mostrarSeguindo :: Connection -> String -> IO()
mostrarSeguindo conn login = do
    seguidores <- getSeguindo conn login
    putStrLn seguidores

seguir :: Connection -> String -> String -> IO()
seguir conn login nome = do
    followFriend conn login nome
    putStrLn "Seguindo com sucesso!"
    putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
    return ()

mostrarSeguidores :: Connection -> String -> IO()
mostrarSeguidores conn login = do
    seguidores <- getSeguidores conn login
    putStrLn seguidores