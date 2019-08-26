module Lib where

import           CompanyModel                   ( select )
import           Data.ByteString.Lazy.Char8     ( pack )
import           Database.HDBC.PostgreSQL       ( Connection )
import           Network.HTTP.Types             ( status200 )
import           Network.Wai                    ( Application
                                                , responseLBS
                                                )
import           Network.Wai.Handler.Warp       ( run )
import           PostgresUtil                   ( connect )

serve :: IO ()
serve = do
    conn <- connect
    putStrLn "http://localhost:8080/"
    run 8080 $ app conn

app :: Connection -> Application
app conn _ respond = do
    cs <- select conn
    putStrLn "select company"
    respond
        . responseLBS status200 [("Content-Type", "text/text")]
        . pack
        . show
        $ cs
