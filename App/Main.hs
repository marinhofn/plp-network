{-# LANGUAGE OverloadedStrings #-}
module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB

main:: IO()
main = do
    conn <- iniciandoDatabase
    print "oi"
