{-# LANGUAGE OverloadedStrings #-}

module Pixiv.Types.ImageURLs(
    ImageURLs(ImageURLs,px_128x128,px_480mw,large)
)where

import Data.Aeson
import Data.Text

data ImageURLs = ImageURLs {
    px_128x128 :: Text,
    px_480mw :: Text,
    large :: Text 
}deriving (Eq,Show)

instance FromJSON ImageURLs where
    parseJSON = withObject "ImageURLs" $ \o -> do
        px128 <- o .: "px_128x128"
        px480 <- o .: "px_480mw"
        large <- o .: "large"
        return $ ImageURLs px128 px480 large
