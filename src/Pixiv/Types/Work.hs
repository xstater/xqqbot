{-# LANGUAGE OverloadedStrings #-}

module Pixiv.Types.Work(
    Work(
        Work,
        workID,
        title,
        caption,
        tags,
        tools,
        imageURLs,
        width,
        height,
        stats,
        publicity,
        ageLimit,
        createdTime,
        reuploadedTime,
        user,
        isManga,
        isLiked,
        favoriteID,
        pageCount,
        bookStyle,
        workType,
        metadata,
        contentType,
        sanityLevel)
)where

import Data.Aeson
import Data.Text
import Pixiv.Types.ImageURLs
import Pixiv.Types.Stats
import Pixiv.Types.User
import Pixiv.Types.Metadata

data Work = Work {
    workID :: Int,
    title :: Text,
    caption :: Text,
    tags :: [Text],
    tools :: [Text],
    imageURLs :: ImageURLs,
    width :: Int,
    height :: Int,
    stats :: Stats,
    publicity :: Int,
    ageLimit :: Text,
    createdTime :: Text,
    reuploadedTime :: Text,
    user :: User,
    isManga :: Bool,
    isLiked :: Bool,
    favoriteID :: Int,
    pageCount :: Int,
    bookStyle :: Text,
    workType :: Text,
    metadata :: Maybe Metadata,
    contentType :: Text,
    sanityLevel :: Text
}deriving (Eq,Show)

instance FromJSON Work where
    parseJSON = withObject "Work" $ \o ->
        Work `fmap`
        (o .:? "id" .!= 0) <*>
        (o .:? "title" .!= "") <*>
        (o .:? "caption" .!= "") <*>
        (o .:? "tags" .!= []) <*>
        (o .:? "tools" .!= []) <*>
        (o .: "image_urls") <*>
        (o .:? "width" .!= 0) <*>
        (o .:? "height" .!= 0) <*>
        (o .: "stats") <*>
        (o .:? "publicity" .!= 0) <*>
        (o .:? "age_limit" .!= "") <*>
        (o .:? "created_time" .!= "") <*>
        (o .:? "reuploaded_time" .!= "") <*>
        (o .: "user") <*>
        (o .:? "is_manga" .!= False) <*>
        (o .:? "is_liked" .!= False) <*>
        (o .:? "favorite_id" .!= 0) <*>
        (o .: "page_count") <*>
        (o .:? "book_style" .!= "") <*>
        (o .:? "type" .!= "") <*>
        (pure Nothing) <*> --metadata here
        (o .:? "content_type" .!= "") <*>
        (o .:? "sanity_level" .!= "")

        

