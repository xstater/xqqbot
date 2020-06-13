
module Data.Aeson.Cursor(
    (/@)
)where

import Control.Monad 
import Data.Aeson
import Data.Text
import qualified Data.HashMap.Strict as HM

(/@) :: Maybe Value -> Text -> Maybe Value
(Just (Object obj)) /@ name = HM.lookup name obj
_ /@ _ = Nothing



