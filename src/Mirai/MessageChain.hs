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
    toJsonTextChain
)where

import Data.Text
import Data.Aeson hiding (object)
import Data.Aeson.Constructor

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
    ("Content" //: string c))
toJsonText (Poke n) = object ( 
    ("type" //: string "Poke") </>
    ("name" //: string n))