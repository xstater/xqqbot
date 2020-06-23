{-# LANGUAGE OverloadedStrings #-}

module Pixiv.Types.User(
    User(User,userID,account,name,isFollowing,isFollower,isPremium)
)where

import Data.Aeson
import Data.Text

data User = User {
    userID :: Int,
    account :: Text,
    name :: Text,
    isFollowing :: Bool,
    isFollower :: Bool,
    isFriend :: Bool,
    isPremium :: Bool
    -- profileImageURLs ::,
    -- stats :: 
    -- profile ::
} deriving (Eq,Show)

instance FromJSON User where
    parseJSON = withObject "User" $ \o -> do
        uid <- o .:? "id" .!= 0
        acc <- o .:? "account" .!= ""
        nm <- o .:? "name" .!= ""
        fli <- o .: "is_following" .!= False
        fle <- o .:? "is_follower" .!= False
        fre <- o .:? "is_friend" .!= False
        pre <- o .:? "is_premium" .!= False
        return $ User uid acc nm fli fle fre pre
