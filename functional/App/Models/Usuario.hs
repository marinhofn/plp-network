{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
module Models.Usuario where
    import GHC.Generics (Generic)
    import Database.PostgreSQL.Simple (FromRow)
    data Usuario = Usuario {
            idUser:: String, --nome do usuario
            senha:: String
        } deriving (Show, Read, Generic, FromRow)