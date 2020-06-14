{-# LANGUAGE OverloadedStrings #-}

module Mirai.MessageChain(
    Message(
        Source,Quote,At,AtAll,Face,Plain,Image,FlashImage,Xml,Json,App,Poke,
        messageID,
        time,
        groupID,
        senderID,
        targetID,
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
    MessageChain,
    toJsonText,
    toJsonTextChain,
    fromJsonValue,
    fromJsonValueChain
)where

import Data.Text
import Data.Aeson hiding (object,json)
import Data.Aeson.Constructor
import Data.Aeson.Cursor
import Data.Aeson.Convert
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
    targetID :: Int
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

toJsonTextChain :: MessageChain -> Text
toJsonTextChain = array . Prelude.map toJsonText
        
toJsonText :: Message -> Text
toJsonText (Source mid tim) = object ( 
    ("type" //: string "Source") </> 
    ("id" //: number mid) </>
    ("time" //: number tim))
toJsonText (Quote mid gid sid tid org) = object ( 
    ("type" //: string "Quote") </> 
    ("id" //: number mid) </>
    ("groupId" //: number gid) </>
    ("senderId" //: number sid) </>
    ("targetId" //: number tid) </>
    ("origin" //: toJsonTextChain org))
toJsonText (At tid) = object ( 
    ("type" //: string "At") </> 
    ("target" //: number tid))
toJsonText AtAll = object ( 
    ("type" //: string "AtAll"))
toJsonText (Face fid nam) = object ( 
    ("type" //: string "Face") </>
    ("faceId" //: number fid) </>
    ("name" //: string nam))
toJsonText (Plain txt) = object ( 
    ("type" //: string "Plain") </>
    ("text" //: string txt))
toJsonText (Image iid u pth) = object ( 
    ("type" //: string "Image") </>
    ("imageId" //: string iid) </>
    ("url" //: string u) </>
    ("path" //: string pth))
toJsonText (FlashImage iid u pth) = object ( 
    ("type" //: string "FlashImage") </>
    ("imageId" //: string iid) </>
    ("url" //: string u) </>
    ("path" //: string pth))
toJsonText (Xml x) = object ( 
    ("type" //: string "Xml") </>
    ("xml" //: string x))
toJsonText (Json j) = object ( 
    ("type" //: string "Json") </>
    ("josn" //: string j))
toJsonText (App c) = object ( 
    ("type" //: string "App") </>
    ("content" //: string c))
toJsonText (Poke n) = object ( 
    ("type" //: string "Poke") </>
    ("name" //: string n))

fromJsonValueChain :: Maybe Value -> MessageChain
fromJsonValueChain jsn = case jsn of
    (Just (Array arr)) -> toList $ (fromJsonValue . Just) `fmap` arr
    _ -> []

fromJsonValue :: Maybe Value -> Message
fromJsonValue jsn = case jsn /@ "type" >>= convert :: Maybe Text of
    (Just "Source") -> Source {
        messageID = 0 `fromMaybe` (jsn /@ "id" >>= convert),
        time = 0 `fromMaybe` (jsn /@ "time" >>= convert)
    }
    (Just "Quote") -> Quote {
        messageID = 0 `fromMaybe` (jsn /@ "id" >>= convert),
        groupID = 0 `fromMaybe` (jsn /@ "groupId" >>= convert),
        senderID = 0 `fromMaybe` (jsn /@ "senderId" >>= convert),
        targetID = 0 `fromMaybe` (jsn /@ "targetId" >>= convert),
        origin = fromJsonValueChain (jsn /@ "origin")
    }
    (Just "At") -> At {
        targetID = 0 `fromMaybe` (jsn /@ "target" >>= convert)
    }
    (Just "AtAll") -> AtAll
    (Just "Face") -> Face {
        faceID = 0 `fromMaybe` (jsn /@ "faceId" >>= convert),
        name = "" `fromMaybe` (jsn /@ "name" >>= convert)
    }
    (Just "Plain") -> Plain {
        text = "" `fromMaybe` (jsn /@ "text" >>= convert)
    }
    (Just "Image") -> Image {
        imageID = "" `fromMaybe` (jsn /@ "imageId" >>= convert),
        url = "" `fromMaybe` (jsn /@ "url" >>= convert),
        path = "" `fromMaybe` (jsn /@ "path" >>= convert)
    }
    (Just "FlashImage") -> FlashImage {
        imageID = "" `fromMaybe` (jsn /@ "imageId" >>= convert),
        url = "" `fromMaybe` (jsn /@ "url" >>= convert),
        path = "" `fromMaybe` (jsn /@ "path" >>= convert)
    }
    (Just "Xml") -> Xml {
        xml = "" `fromMaybe` (jsn /@ "xml" >>= convert)
    }
    (Just "Json") -> Json {
        json = "" `fromMaybe` (jsn /@ "json" >>= convert)
    }
    (Just "App") -> App {
        content = "" `fromMaybe` (jsn /@ "content" >>= convert)
    }
    (Just "Poke") -> Poke {
        name = "" `fromMaybe` (jsn /@ "name" >>= convert)
    }
    _ -> Plain ""