module Menus.MenuTerminal where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
--import Menus.MenuTerminal
import Data.Time.Clock
import Data.Time.Clock.POSIX
import System.Process
import System.Console.ANSI
import Services.UsuarioService;
import Services.TweetService;
import System.IO.Error
import Control.Exception
import Models.Tweet

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
    
-- Menu
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

-- Menu de login
loginTerminal :: IO()
loginTerminal = do
    clearScreen
    title

    putStrLn "Digite seu login: "
    login <- getLine
    putStrLn "Digite sua senha: "
    senha <- getLine

    conn <- iniciandoDatabase
    validado <- validarLogin conn login senha

    --usuario <- getUsuario conn login
    --usuarioSenha <- getSenha conn login

    if validado then do
        putStrLn "\nLogin efetuado com sucesso!"
        putStrLn "Pressione qualquer botão para continuar..."
        aux <- getLine
        menuUsuario login conn
    else do
        putStrLn "\nLogin ou senha inválidos!"
        putStrLn "Pressione qualquer botão para voltar ao menu inicial..."
        aux <- getLine
        menuInicial


-- Menu de Cadastro
cadastroTerminal :: IO()
cadastroTerminal = do
    clearScreen
    title

    putStrLn "Digite o nome de usuário:"
    nome <- getLine
    putStrLn "Digite a senha:"
    senha <- getLine
    
    conn <- iniciandoDatabase
    cadastro conn nome senha    
    menuInicial

-- Cadastrar um novo usuário
cadastro :: Connection -> String -> String -> IO()
cadastro conn nome senha = do
 
    putStrLn "\nCadastrando..."

    -- FUNCIONANDO
    -- conn <- iniciandoDatabase
    realizarCadastro conn nome senha

-------------------------------------------------------

-- Menu de funções para um Usuario já logado
menuUsuario :: String -> Connection -> IO()
menuUsuario login conn = do
    clearScreen
    title
    --putStrLn "\nLogin efetuado com sucesso!\n"
    putStrLn "1 - Criar um novo tweet"
    putStrLn "2 - Ver seus tweets"
    putStrLn "3 - Ver seus seguidores"
    putStrLn "4 - Ver quem você segue"
    putStrLn "\n5 - Deslogar\n"
    op <- getLine
    redirectMenuUsuario login conn op

-- Redirecionar do Menu de Usuario para a função desejada
redirectMenuUsuario ::String -> Connection -> String -> IO()
redirectMenuUsuario login conn op
    | op == "1" = criarTweetMenu login conn
    | op == "2" = verTweets conn login
    | op == "3" = verSeguidores login conn
    | op == "4" = verSeguindo login conn
    | op == "5" = sair
    | otherwise = do
        putStrLn "Opção inválida!"
        menuUsuario login conn


criarTweetMenu :: String -> Connection -> IO()
criarTweetMenu login conn = do
    clearScreen
    title
    putStrLn "Digite o conteúdo do tweet: "
    conteudo <- getLine
    actualTime <- getCurrentTime

    --TODO: verificar a funcionalidade da criacao do Tweet
    criarTweetService login conn conteudo actualTime
    --insertTweet login conn conteudo

    putStrLn "\nTweet publicado!"

    putStrLn "Pressione qualquer botão para voltar ao menu inicial..."

    aux <- getLine
    menuUsuario login conn

verTweets :: Connection -> String -> IO()
verTweets conn login = do
    --TODO: remover o id do usuario e pegar o id do usuario logado
    putStrLn "\n - vendo tweets - \n"
    
    --mostrarListaTweet (listarTweetsUsuario conn login)    

    -- id <- getLine
    --conn <- iniciandoDatabase
    --tweets <- getTweets conn id
    --print tweets
    x <- getLine
    menuUsuario login conn

-- mostrarListaTweet :: IO [Tweet] -> IO()
-- mostrarListaTweet [] = putStrLn "Nada para mostrar"
-- mostrarListaTweet (x:xs) = do
--     putStrLn (show (idTweet x) ++ " - " ++ conteudo x ++ "\n")
--     mostrarListaTweet xs

verSeguidores :: String -> Connection -> IO()
verSeguidores login conn = do
    putStrLn "\n - vendo seguidores - \n"
    
    --id <- getLine
    --conn <- iniciandoDatabase
    --seguidores <- getSeguidores conn id
    --print seguidores

    menuUsuario login conn

verSeguindo :: String -> Connection -> IO()
verSeguindo login conn = do
    putStrLn "\n - vendo quem você segue - \n"
    
    --id <- getLine
    --conn <- iniciandoDatabase
    --seguindo <- getSeguindo conn id
    --print seguindo

    menuUsuario login conn


sair :: IO()
sair = do
    putStrLn "\nSaindo...\n"
    menuInicial