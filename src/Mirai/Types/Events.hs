{-# LANGUAGE OverloadedStrings #-}

module Mirai.Types.Events(
    EventType(
        BotOnline,
        BotOfflineActive,
        BotOfflineForce,
        BotOfflineDropped,
        BotRelogin,
        ReceivedGroupMessage,
        ReceivedFriendMessage,
        UnknownEvent)
)where

import Data.Aeson
import Data.Text
import Mirai.Types.MessageChain 
import Mirai.Types.GroupMessage as GM
import Mirai.Types.FriendMessage as FM

data EventType = 
    BotOnline Int | 
    BotOfflineActive Int |
    BotOfflineForce Int |
    BotOfflineDropped Int |
    BotRelogin Int|
    ReceivedGroupMessage GroupMessage |
    ReceivedFriendMessage FriendMessage |
    UnknownEvent deriving (Eq,Show)

instance FromJSON EventType where
    parseJSON = withObject "EventType" $ \o -> do
        t <- o .: "type"
        case t :: Text of
            "BotOnlineEvent" -> do
                qq <- o .: "qq"
                return $ BotOnline qq
            "BotOfflineEventActive" -> do
                qq <- o .: "qq"
                return $ BotOfflineActive qq
            "BotOfflineEventForce" -> do
                qq <- o .: "qq"
                return $ BotOfflineForce qq
            "BotOfflineEventDropped" -> do
                qq <- o .: "qq"
                return $ BotOfflineDropped qq
            "BotReloginEvent" -> do
                qq <- o .: "qq"
                return $ BotRelogin qq
            "GroupMessage" -> do
                msgc <- o .: "messageChain"
                sndr <- o .: "sender"
                return $ ReceivedGroupMessage $ GroupMessage msgc sndr
            "FriendMessage" -> do
                msgc <- o .: "messageChain"
                sndr <- o .: "sender"
                return $ ReceivedFriendMessage $ FriendMessage msgc sndr
            _ -> return UnknownEvent
