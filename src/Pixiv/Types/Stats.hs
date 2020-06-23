{-# LANGUAGE OverloadedStrings #-}

module Pixiv.Types.Stats(
    FavoritedCount(FavoritedCount,public,private),
    Stats(Stats,scoreCount,score,viewsCount,favoritedCount,commentedCount)
)where

import Data.Aeson
import Data.Text

data FavoritedCount = FavoritedCount {
    public :: Int,
    private :: Int
} deriving (Eq,Show)

instance FromJSON FavoritedCount where
    parseJSON = withObject "FavoritedCount" $ \o -> do
        pb <- o .:? "public"  .!= 0
        pv <- o .:? "private" .!= 0
        return $ FavoritedCount pb pv

data Stats = Stats {
    scoreCount :: Int,
    score :: Int,
    viewsCount :: Int,
    favoritedCount :: FavoritedCount,
    commentedCount :: Int
} deriving (Eq,Show)

instance FromJSON Stats where
    parseJSON = withObject "Stats" $ \o -> do
        scc <- o .:? "scored_count" .!= 0
        sc <- o .:? "score" .!= 0
        vc <- o .:? "views_count" .!= 0
        fc <- o .: "favorited_count"
        cc <- o .:? "commented_count" .!= 0
        return $ Stats scc sc vc fc cc
