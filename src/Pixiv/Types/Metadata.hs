{-# LANGUAGE OverloadedStrings #-}

module Pixiv.Types.Metadata(
    Metadata(Metadata)
)where

import Data.Aeson
import Data.Text

data Metadata = Metadata deriving (Eq,Show)

instance FromJSON Metadata where
    parseJSON = withObject "Metadata" $ \o -> do
        return Metadata
