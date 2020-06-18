{-# LANGUAGE OverloadedStrings #-}

module Mirai.Api.About(
    About(About,version),
    about
)where

import Data.Aeson
import Data.Text
import Control.Monad.Except
import Mirai.Config
import Mirai.Types.StatusCode
import Mirai.Api
import Network.HTTP.Req

data About = About {
    version :: Text
} deriving (Eq,Show)

data AboutData = AboutData Text deriving (Eq,Show)
instance FromJSON AboutData where
    parseJSON = withObject "AboutData" $ \o -> AboutData `fmap` (o .: "version")

data AboutResponse = AboutResponse StatusCode Text AboutData deriving (Eq,Show)
instance FromJSON AboutResponse where
    parseJSON = withObject "AboutResponse" $ \o -> AboutResponse `fmap` (o .: "code") <*> (o .: "errorMessage") <*> (o .: "data")

about :: Session About
about = do
    jsn <- req GET (apiBaseURL /: "about") NoReqBody jsonResponse (port apiBasePort)
    let (AboutResponse c errmsg (AboutData vers)) = responseBody jsn
    case c of
        Ok -> return $ About vers
        _ -> throwError $ unpack errmsg
