module PostgresUtil
    ( connect
    , defineTable
    )
where

import           Database.HDBC.PostgreSQL       ( Connection
                                                , connectPostgreSQL
                                                )
import           Database.HDBC.Schema.PostgreSQL
                                                ( driverPostgreSQL )
import           Database.HDBC.Query.TH         ( defineTableFromDB )
import           GHC.Generics                   ( Generic )
import           Language.Haskell.TH            ( Q
                                                , Dec
                                                )
import           System.Environment             ( getEnv )

connect :: IO Connection
connect = do
    host     <- getEnv "DB_HOST"
    user     <- getEnv "POSTGRES_USER"
    db       <- getEnv "POSTGRES_DB"
    password <- getEnv "POSTGRES_PASSWORD"
    let conninfo = unwords
            [ "host=" <> host
            , "user=" <> user
            , "dbname=" <> db
            , "password=" <> password
            ]
    connectPostgreSQL conninfo

defineTable :: String -> String -> Q [Dec]
defineTable schema table =
    defineTableFromDB connect driverPostgreSQL schema table [''Generic, ''Show]
