module CompanyModel where

import           Prelude                 hiding ( id )
import qualified CompanyEntity                 as CE
import           Data.Time                      ( LocalTime )
import           Database.HDBC.PostgreSQL       ( Connection )
import           Database.Relational            ( Relation
                                                , query
                                                , relation
                                                , relationalQuery
                                                )
import           Database.HDBC.Record.Query     ( runQuery )

newtype CompanyId = CompanyId Int
    deriving Show

data Company = Company
    { id :: CompanyId
    , name :: String
    , establishmentYear :: Int
    , createdAt :: LocalTime
    }
    deriving Show

fromEntity :: CE.Company -> Company
fromEntity e = Company
    { id                = CompanyId . fromIntegral . CE.id $ e
    , name              = CE.name e
    , establishmentYear = fromIntegral $ CE.establishmentYear e
    , createdAt         = CE.createdAt e
    }

select :: Connection -> IO [Company]
select conn = do
    es <- runQuery conn (relationalQuery select') ()
    return $ map fromEntity es
  where
    select' :: Relation () CE.Company
    select' = relation $ query CE.company
