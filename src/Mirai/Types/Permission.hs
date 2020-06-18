{-# LANGUAGE OverloadedStrings #-}

module Mirai.Types.Permission(
    Permission(Owner,Administrator,Member)
)where

import Data.Aeson

data Permission = Owner | Administrator | Member deriving (Eq,Show)

instance ToJSON Permission where
    toJSON Owner = String "OWNER"
    toJSON Administrator = String "ADMINISTRATOR"
    toJSON Member = String "MEMBER"

instance FromJSON Permission where
    parseJSON = withText "Permission" $ \t -> case t of
        "OWNER" -> return Owner
        "ADMINISTRATOR" -> return Administrator
        "MEMBER" -> return Member
        _ -> return Member