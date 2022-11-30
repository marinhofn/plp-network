module Menus.MenuTerminal where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Services.CurtidaService
import Services.RespostaService

import Data.Time.Clock
import Data.Time.Clock.POSIX
import System.Process
import System.Console.ANSI
import Services.UsuarioService;
import Services.TweetService;
import System.IO.Error
import Control.Exception
import Models.Tweet

-- title :: IO()
-- title = do
--     setCursorPosition 5 0
--     putStrLn  "          _______         __                           __    "
--     putStrLn  "         |    |  |.-----.|  |_ .--.--.--..-----..----.|  |--."
--     putStrLn  "         |       ||  -__||   _||  |  |  ||  _  ||   _||    < "
--     putStrLn  "         |__|____||_____||____||________||_____||__|  |__|__|"
--     putStrLn  "\n"                                                     

title :: IO()
title = do
    setCursorPosition 5 0
    putStrLn "\nTWEETTER\n"
    
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


cadastro :: Connection -> String -> String -> IO()
cadastro conn nome senha = do 
    putStrLn "\nCadastrando..."
    realizarCadastro conn nome senha

menuUsuario :: String -> Connection -> IO()
menuUsuario login conn = do
    clearScreen
    title
    
    putStrLn "1 - Criar um novo tweet"
    putStrLn "2 - Ver seus tweets"
    putStrLn "3 - Ver seus seguidores"
    putStrLn "4 - Ver quem você segue"
    putStrLn "5 - Ver timeline"
    putStrLn "6 - Seguir amigo"
    putStrLn "\n7 - Deslogar\n"

    op <- getLine
    redirectMenuUsuario login conn op


redirectMenuUsuario ::String -> Connection -> String -> IO()
redirectMenuUsuario login conn op
    | op == "1" = criarTweetMenu login conn
    | op == "2" = verTweets conn login
    | op == "3" = verSeguidores login conn
    | op == "4" = verSeguindo login conn
    | op == "5" = verTimeLine conn login
    | op == "6" = seguirAmigoMenu conn login
    | op == "7" = sair
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

    criarTweetService login conn conteudo actualTime

    putStrLn "\nTweet publicado!"

    putStrLn "Pressione qualquer botão para voltar ao menu inicial..."

    aux <- getLine
    menuUsuario login conn

verTweets :: Connection -> String -> IO()
verTweets conn login = do

    putStrLn "\nTweets: \n"    
    tweets <- getTweetsUsuario conn login
    mostrarTweets tweets
    x <- getLine
    menuUsuario login conn

-- TODO: Adicionar operação de selecionar tweet
verTimeLine :: Connection -> String -> IO()
verTimeLine conn login = do
    clearScreen
    title
    putStrLn "\nTimeLine: \n"
    tweets <- getTimeLine conn login
    mostrarTweets tweets

    id <- getLine
    let idTweet = read id:: Int
    acessarTweetFromTimeline conn login idTweet

    menuUsuario login conn

acessarTweetFromTimeline :: Connection -> String -> Int -> IO()
acessarTweetFromTimeline conn login idTweet = do
    clearScreen
    title
    tweet <- getTweetService conn idTweet
    getTweetWithResponsesService conn (getId tweet)    
    putStrLn "1 - Curtir    2 - Responder    3 - Voltar"
    op <- getLine
    timelineMenu conn login op idTweet

    menuUsuario login conn

timelineMenu :: Connection -> String -> String -> Int -> IO()
timelineMenu conn login op idTweet
    | op == "1" = curtirTweet conn login idTweet
    -- | op == "2" = responderTweet conn login idTweet
    | op == "3" = menuUsuario login conn
    | otherwise = do
        putStrLn "Opção inválida!"
        menuUsuario login conn

curtirTweet :: Connection -> String -> Int -> IO()
curtirTweet conn login idTweet = do
    addCurtida conn login idTweet
    acessarTweetFromTimeline conn login idTweet 
    aux <- getLine
    menuUsuario login conn

verSeguindo :: String -> Connection -> IO()
verSeguindo login conn = do
    putStrLn "\nSeguindo: \n"   
    mostrarSeguindo conn login 
    x <- getLine
    menuUsuario login conn

seguirAmigoMenu :: Connection -> String -> IO()
seguirAmigoMenu conn login = do
    putStrLn "Digite o nome do usuário que deseja seguir: "
    nome <- getLine
    seguir conn login nome
    
    x <- getLine
    menuUsuario login conn

verSeguidores :: String -> Connection -> IO()
verSeguidores login conn = do
    putStrLn "\nSeguidores \n"
        
    mostrarSeguidores conn login
    x <- getLine
    menuUsuario login conn

sair :: IO()
sair = do
    putStrLn "\n\n  shutting down   \n"
    menuInicial