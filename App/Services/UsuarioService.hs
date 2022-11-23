-- TODO
module Services.UsuarioService where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository

realizarCadastro :: Connection -> String -> String -> IO ()
realizarCadastro conn nome senha = do
    --conn <- iniciandoDatabase
    cadastrarUsuario conn nome senha
    putStrLn "Cadastro efetuado com sucesso!"
    putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
    aux <- getLine
    return ()