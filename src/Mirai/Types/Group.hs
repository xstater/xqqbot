{-# LANGUAGE OverloadedStrings #-}

module Mirai.Types.Group(
    Group(
        Group,
        groupID,
        groupName,
        groupPermission)
)where

import Data.Aeson
import Data.Text
import Mirai.Types.Permission

data Group = Group {
    groupID :: Int,
    groupName :: Text,
    groupPermission :: Permission
}deriving (Eq,Show)

instance FromJSON Group where
    parseJSON = withObject "Group" $ \o -> 
        Group `fmap` (o .: "id") <*> (o .: "name") <*> (o .: "permission")
