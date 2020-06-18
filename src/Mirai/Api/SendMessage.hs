{-# LANGUAGE OverloadedStrings #-}

module Mirai.Api.SendMessage(
    sendFriendMessage,
    sendGroupMessage
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

data MessageResponse = MessageResponse StatusCode Text Int deriving (Eq,Show)
instance FromJSON MessageResponse where
    parseJSON = withObject "MessageResponse" $ \o -> MessageResponse `fmap` (o .: "code") <*> (o .: "msg") <*> (o .: "messageId")

sendFriendMessage :: Int -> MessageChain -> Session Int
sendFriendMessage qq msgc = do
    (sid,_) <- get
    jsn <- req POST (apiBaseURL /: "sendFriendMessage")
        (ReqBodyJson $ object ["sessionKey" .= sid,"target" .= qq,"messageChain" .= msgc]) jsonResponse (port apiBasePort)
    let (MessageResponse c msg mid) = responseBody jsn
    case c of
        Ok -> return mid
        _ -> throwError $ Data.Text.unpack msg

sendGroupMessage :: Int -> MessageChain -> Session Int
sendGroupMessage qq msgc = do
    (sid,_) <- get
    jsn <- req POST (apiBaseURL /: "sendGroupMessage")
        (ReqBodyJson $ object ["sessionKey" .= sid,"target" .= qq,"messageChain" .= msgc]) jsonResponse (port apiBasePort)
    let (MessageResponse c msg mid) = responseBody jsn
    case c of
        Ok -> return mid
        _ -> throwError $ Data.Text.unpack msg