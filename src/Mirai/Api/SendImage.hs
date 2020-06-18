{-# LANGUAGE OverloadedStrings #-}

module Mirai.Api.SendImage(
    sendImageMessage
)where

import Data.Aeson
import Data.Text
import Control.Monad.Except
import Control.Monad.State.Lazy
import Mirai.Types.MessageChain
import Mirai.Types.StatusCode
import Mirai.Config
import Mirai.Api
import Network.HTTP.Req

sendImageMessage :: Int -> [Text] -> Session [Text]
sendImageMessage qq urls = do
    (sid,_) <- get
    jsn <- req POST (apiBaseURL /: "sendImageMessage")
        (ReqBodyJson $ object ["sessionKey" .= sid,"target" .= qq,"urls" .= urls]) jsonResponse (port apiBasePort)
    return $ responseBody jsn