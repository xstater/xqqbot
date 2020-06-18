{-# LANGUAGE OverloadedStrings #-}

module Mirai.Types.MessageChain(
    Message(
        Source,Quote,At,AtAll,Face,Plain,Image,FlashImage,Xml,Json,App,Poke,
        messageID,
        time,
        groupID,
        senderID,
        targetID,
        display,
        origin,
        faceID,
        name,
        text,
        imageID,
        url,
        path,
        xml,
        json,
        content),
    MessageChain
)where

import Data.Text
import Data.Aeson hiding (json)
import Data.Maybe
import Data.Vector (toList)

data Message = Source {
    messageID :: Int,
    time :: Int
} | Quote {
    messageID :: Int,
    groupID :: Int,
    senderID :: Int,
    targetID :: Int,
    origin :: [Message]
} | At {
    targetID :: Int,
    display :: Text --no use when send
} | AtAll
  | Face {
    faceID :: Int,
    name :: Text
} | Plain {
    text :: Text
} | Image {
    imageID :: Text,
    url :: Text,
    path :: Text
} | FlashImage {
    imageID :: Text,
    url :: Text,
    path :: Text
} | Xml {
    xml :: Text
} | Json {
    json :: Text
} | App {
    content :: Text
} | Poke {
    name :: Text
} deriving (Eq,Show)

type MessageChain = [Message]

instance ToJSON Message where
    -- toJSON :: Message -> Value
    toJSON (Source msgid tim) = object [
        "type" .= ("Source" :: Text),
        "id" .= msgid,
        "time" .= tim]
    toJSON (Quote msgid gid sid tid orgn) = object [
        "type" .= ("Quote" :: Text),
        "id" .= msgid,
        "groupId" .= gid,
        "senderId" .= sid,
        "targetId" .= tid,
        "origin" .= toJSON orgn]
    toJSON (At tid disp) = object [
        "type" .= ("At" :: Text),
        "target" .= tid,
        "display" .= disp]
    toJSON AtAll = object [
        "type" .= ("AtAll" :: Text)]
    toJSON (Face fid nam) = object [
        "type" .= ("Face" :: Text),
        "faceId" .= fid,
        "name" .= nam]
    toJSON (Plain txt) = object [
        "type" .= ("Plain" :: Text),
        "text" .= txt]
    toJSON (Image imgid u pth) = object [
        "type" .= ("Image" :: Text),
        "imageId" .= imgid,
        "url" .= u,
        "path" .= pth]
    toJSON (FlashImage imgid u pth) = object [
        "type" .= ("FlashImage" :: Text),
        "imageId" .= imgid,
        "url" .= u,
        "path" .= pth]
    toJSON (Xml x) = object [
        "type" .= ("Xml" :: Text),
        "xml" .= x]
    toJSON (Json j) = object [
        "type" .= ("Json" :: Text),
        "json" .= j]
    toJSON (App c) = object [
        "type" .= ("App" :: Text),
        "content" .= c]
    toJSON (Poke n) = object [
        "type" .= ("Poke" :: Text),
        "name" .= n]

instance FromJSON Message where
    parseJSON = withObject "Message" $ \o -> do
        t <- o .: "type"
        case t :: Text of
            "Source" -> do
                msgid <- o .: "id"
                tim <- o .: "time"
                return $ Source msgid tim
            "Quote" -> do
                msgid <- o .: "id"
                gid <- o .: "groupId"
                sid <- o .: "senderId"
                tid <- o .: "targetId"
                orgn <- o .: "origin"
                return $ Quote msgid gid sid tid orgn
            "At" -> do
                tid <- o .: "target"
                disp <- o .: "display"
                return $ At tid disp
            "AtAll" -> return AtAll
            "Face" -> do
                fid <- o .: "faceId"
                nam <- o .: "name"
                return $ Face fid nam
            "Plain" -> do
                txt <- o .: "text"
                return $ Plain txt
            "Image" -> do
                imgid <- o .: "imageId"
                u <- o .: "url"
                pth <- o .: "path"
                return $ Image imgid u pth
            "FlashImage" -> do
                imgid <- o .: "imageId"
                u <- o .: "url"
                pth <- o .: "path"
                return $ FlashImage imgid u pth
            "Xml" -> do
                x <- o .: "xml"
                return $ Xml x
            "Json" -> do
                j <- o .: "json"
                return $ Json j
            "App" -> do
                c <- o .: "content"
                return $ App c
            "Poke" -> do
                n <- o .: "name"
                return $ Poke n
        