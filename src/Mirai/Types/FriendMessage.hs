{-# LANGUAGE OverloadedStrings #-}
{-#LANGUAGE ScopedTypeVariables #-}

module Mirai.Types.FriendMessage(
    Sender(
        Sender,
        qq,
        name,
        remark),
    FriendMessage(
        FriendMessage,
        messageChain,
        sender)
)where

import Data.Text
import Data.Aeson
import Mirai.Types.Permission
import Mirai.Types.MessageChain

data Sender = Sender {
    qq :: Int,
    name :: Text,
    remark :: Text
} deriving (Eq,Show)

instance FromJSON Sender where
    parseJSON = withObject "Sender" $ \o -> 
        Sender `fmap` 
        (o .: "id") <*> 
        (o .: "name") <*>
        (o .: "remark")

data FriendMessage = FriendMessage {
    messageChain :: MessageChain,
    sender :: Sender
}deriving (Eq,Show)

instance FromJSON FriendMessage where
    parseJSON = withObject "FriendMessage" $ \o -> do
        (_ :: Text) <- o .: "type"
        msgc <- o .: "messageChain"
        sndr <- o .: "sender"
        return $ FriendMessage msgc sndr

