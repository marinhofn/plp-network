-- TODO
module Services.UsuarioService where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository

realizarCadastro :: Connection -> String -> String -> IO ()
realizarCadastro conn nome senha = do
    cadastrarUsuario conn nome senha
    putStrLn "Cadastro efetuado com sucesso!"
    putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
    aux <- getLine
    return ()


getUsuario :: Connection -> String -> IO String
getUsuario conn login = do
    putStrLn "Validando Usuário..."
    nome <- validarUsuario conn login
    return nome

getSenha :: Connection -> String -> IO String
getSenha conn login = do
    putStrLn "Validando Senha..."
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