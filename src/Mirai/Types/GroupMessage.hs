{-# LANGUAGE OverloadedStrings #-}
{-#LANGUAGE ScopedTypeVariables #-}

module Mirai.Types.GroupMessage(
    Group(
        Group,
        groupID,
        groupName,
        groupPermission),
    Sender(
        Sender,
        memberQQ,
        memberName,
        memberPermission,
        group),
    GroupMessage(
        GroupMessage,
        messageChain,
        sender)
)where

import Data.Text
import Data.Aeson
import Mirai.Types.Permission
import Mirai.Types.MessageChain

data Group = Group {
    groupID :: Int,
    groupName :: Text,
    groupPermission :: Permission
}deriving (Eq,Show)

instance FromJSON Group where
    parseJSON = withObject "Group" $ \o -> 
        Group `fmap` (o .: "id") <*> (o .: "name") <*> (o .: "permission")

data Sender = Sender {
    memberQQ :: Int,
    memberName :: Text,
    memberPermission :: Permission,
    group :: Group
} deriving (Eq,Show)

instance FromJSON Sender where
    parseJSON = withObject "Sender" $ \o -> 
        Sender `fmap` 
        (o .: "id") <*> 
        (o .: "memberName") <*>
        (o .: "permission") <*>
        (o .: "group") 

data GroupMessage = GroupMessage {
    messageChain :: MessageChain,
    sender :: Sender
}deriving (Eq,Show)

instance FromJSON GroupMessage where
    parseJSON = withObject "GroupMessage" $ \o -> do
        (_ :: Text) <- o .: "type"
        msgc <- o .: "messageChain"
        sndr <- o .: "sender"
        return $ GroupMessage msgc sndr


