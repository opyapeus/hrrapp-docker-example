module CompanyEntity where

import           Prelude                 hiding ( id )
import           PostgresUtil                   ( defineTable )

$(defineTable "master" "company")
