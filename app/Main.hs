{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Aeson hiding (object)
import Data.Aeson.Cursor
import Data.Aeson.Constructor
import Mirai.Api
import Network.HTTP.Req
import Data.ByteString
import Mirai.MessageChain

-- main :: IO ()
-- main = scotty 23312 $ do
--     post "/" $ do
--         bodyData <- body
--         liftAndCatchIO $ print bodyData

-- main :: IO ()
-- main = do
--     let jsn = decode "{\"info\":{\"name\":\"fuck\",\"age\":123}}" :: Maybe Value
--     print $ jsn /@ "info" /@ "name"
--     print $ jsn /@ "info" /@ "age"
--     print $ jsn /@ "nmsl" /@ "shit"
--     print $ jsn /@ "info" /@ "fuck"

-- main :: IO ()
-- main = do
--     print $ "asd" //: (number 3)
--     print $ object $ (
--         ("name" //: string "jack") </>
--         ("age"  //: number 1) </>
--         ("array"//: (array $ number `fmap` [1..10])))

-- main :: IO ()
-- main = do
--     res <- runSession "INITKEYBFRTEEI2" 2022847429 $ do
--         -- sendFriendMessage 1209635268 "test"
--         sendGroupMessage 795831442 [At 1209635268,Plain "asd",Image "" "" "test.jpg"]
--         -- sendImageMessage 795831442 "https://pixiv.re/27041254.jpg"
--         -- sendGroupLocalImage 795831442 "test.jpg"
--     print res 
--     -- jpg <- runReq defaultHttpConfig $ do
--     --     response <- req GET (https "pixiv.re" /: "27041254.jpg") NoReqBody bsResponse mempty
--     --     return (responseBody response :: ByteString)
--     -- Data.ByteString.writeFile "test.jpg" jpg

main :: IO ()
main = do
    print $ toJsonTextChain [Plain "asd",At 123]
    let jsn = decode "{\"type\":\"Quote\",\"id\":14213,\"targetId\":1123,\"origin\":[{\"type\":\"Plain\",\"text\":\"asdasd\"}]}" :: Maybe Value
    print $ fromJsonValue jsn
