{-# LANGUAGE OverloadedStrings #-}
module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Repositories.UsuarioRepository
import Repositories.TweetRepository

main:: IO()
main = do
    conn <- iniciandoDatabase
    teste <- getTweets conn "usuario4"
    print teste
    print "oi."   
