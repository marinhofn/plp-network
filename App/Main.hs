{-# LANGUAGE OverloadedStrings #-}
module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository
import Menus.MenuTerminal

main:: IO()
main = do
    conn <- iniciandoDatabase
    teste <- getRespostas conn "8"
    print teste
    menuInicial
    print "endinger............"