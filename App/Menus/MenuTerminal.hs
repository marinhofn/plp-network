module Menus.MenuTerminal where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
--import Menus.MenuTerminal
import Data.Time.Clock
import System.Process
import System.Console.ANSI
import Services.UsuarioService;

--   _______         __                           __    
--  |    |  |.-----.|  |_ .--.--.--..-----..----.|  |--.
--  |       ||  -__||   _||  |  |  ||  _  ||   _||    < 
--  |__|____||_____||____||________||_____||__|  |__|__|
--                                                      

-- clear :: IO()
-- clear = system "cls"

title :: IO()
title = do
    setCursorPosition 5 0
    putStrLn  "          _______         __                           __    "
    putStrLn  "         |    |  |.-----.|  |_ .--.--.--..-----..----.|  |--."
    putStrLn  "         |       ||  -__||   _||  |  |  ||  _  ||   _||    < "
    putStrLn  "         |__|____||_____||____||________||_____||__|  |__|__|"
    putStrLn  "\n"                                                      
    

menuInicial :: IO()
menuInicial = do
    clearScreen
    title

    putStrLn "1 - Login"
    putStrLn "2 - Cadastro"
    putStrLn "3 - Sair"
    opcao <- getLine
    case opcao of
        "1" -> loginTerminal
        "2" -> cadastroTerminal
        "3" -> putStrLn "Saindo..."
        _ -> do
            putStrLn "Opção inválida"
            menuInicial

loginTerminal :: IO()
loginTerminal = do
    clearScreen
    title

    putStrLn "Digite seu login: "
    login <- getLine
    putStrLn "Digite sua senha: "
    senha <- getLine

    conn <- iniciandoDatabase
    usuario <- getUsuario conn login
    usuarioSenha <- getSenha conn login

    if usuario == login && usuarioSenha == senha then do
        putStrLn "\nLogin efetuado com sucesso!"
        putStrLn "Pressione qualquer botão para continuar..."
        aux <- getLine
        menuUsuario
    else do
        putStrLn "\nLogin ou senha inválidos!"
        putStrLn "Pressione qualquer botão para tentar novamente..."
        aux <- getLine
        loginTerminal


-- Menu de Cadastro
cadastroTerminal :: IO()
cadastroTerminal = do
    clearScreen
    title

    putStrLn "Digite o nome de usuário:"
    nome <- getLine
    putStrLn "Digite a senha:"
    senha <- getLine
    cadastro nome senha    
    menuInicial

-- Cadastrar um novo usuário
cadastro :: String -> String -> IO()
cadastro nome senha = do
    -- TODO: checar se nome já existe
    putStrLn "\nCadastrando..."

    -- FUNCIONANDO
    conn <- iniciandoDatabase
    -- cadastrarUsuario conn nome senha
    realizarCadastro conn nome senha


-------------------------------------------------------

-- Menu de funções para um Usuario já logado
menuUsuario :: IO()
menuUsuario = do
    clearScreen
    title
    --putStrLn "\nLogin efetuado com sucesso!\n"
    putStrLn "1 - Criar um novo tweet"
    putStrLn "2 - Ver seus tweets"
    putStrLn "3 - Ver seus seguidores"
    putStrLn "4 - Ver quem você segue"
    putStrLn "\n5 - Deslogar\n"
    op <- getLine
    redirectMenuUsuario op

-- Redirecionar do Menu de Usuario para a função desejada
redirectMenuUsuario :: String -> IO()
redirectMenuUsuario op
    | op == "1" = criarTweetMenu
    | op == "2" = verTweets
    | op == "3" = verSeguidores
    | op == "4" = verSeguindo
    | op == "5" = sair
    | otherwise = do
        putStrLn "Opção inválida!"
        menuUsuario


criarTweetMenu :: IO()
criarTweetMenu = do
    clearScreen
    title
    putStrLn "Digite o conteúdo do tweet: "
    conteudo <- getLine
    
    --putStrLn "Digite o id do usuário: "
    --id <- getLine
    print conteudo

    --TODO: verificar a funcionalidade da criacao do Tweet
    --conn <- iniciandoDatabase
    --criarTweet conn conteudo id getCurrentTime False
    --insertTweet conn id conteudo

    menuUsuario

verTweets :: IO()
verTweets = do
    --TODO: remover o id do usuario e pegar o id do usuario logado
    putStrLn "\n - vendo tweets - \n"
    
    -- id <- getLine
    --conn <- iniciandoDatabase
    --tweets <- getTweets conn id
    --print tweets

    menuUsuario

verSeguidores :: IO()
verSeguidores = do
    putStrLn "\n - vendo seguidores - \n"
    
    --id <- getLine
    --conn <- iniciandoDatabase
    --seguidores <- getSeguidores conn id
    --print seguidores

    menuUsuario

verSeguindo :: IO()
verSeguindo = do
    putStrLn "\n - vendo quem você segue - \n"
    
    --id <- getLine
    --conn <- iniciandoDatabase
    --seguindo <- getSeguindo conn id
    --print seguindo

    menuUsuario


sair :: IO()
sair = do
    putStrLn "\nSaindo...\n"
    menuInicial



-- getUsuario :: Connection -> String -> IO Usuario
-- getUsuario conn login = do
--     [usuario] <- query conn "SELECT * FROM usuarios WHERE id = ?" (Only login)
--     return usuario
    