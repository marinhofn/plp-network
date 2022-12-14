{-# LANGUAGE OverloadedStrings #-}
module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Menus.MenuTerminal
import Data.Time.Clock
import Services.TweetService


main:: IO()
main = do
    conn <- iniciandoDatabase  
    menuInicial conn
    putStrLn ""