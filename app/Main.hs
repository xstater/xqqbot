{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Aeson
import Data.Text
import Mirai.Api
import Mirai.Types.StatusCode
import Network.HTTP.Req
import Data.ByteString
import Mirai.Types.MessageChain
import Data.Scientific
import Data.Maybe
import Mirai.Api.SendMessage
import Mirai.Api.SendImage
import Mirai.Api.About
import Control.Monad.IO.Class
import Control.SignalSlot

-- main :: IO ()
-- main = scotty 23312 $ do
--     post "/" $ do
--         bodyData <- body
--         liftAndCatchIO $ print bodyData

-- main :: IO ()
-- main = do
--     res <- runSession "INITKEYBFRTEEI2" 2022847429 $ do
--         a <- about
--         liftIO $ print a
--         -- sendFriendMessage 1209635268 [Plain "asddddd"]
--         -- sendGroupMessage 795831442 [At 1209635268 "",Plain "asd",Image "" "" "test.jpg"]
--         -- sendGroupMessage 795831442 [At 582974615 "",Plain "sb"]
--         -- ids <- sendImageMessage 1209635268 ["https://dss1.bdstatic.com/kvoZeXSm1A5BphGlnYG/skin_zoom/2.jpg"]
--         -- liftIO $ print ids
--         -- return ()
--         -- sendGroupLocalImage 795831442 "test.jpg"
--     print res 
--     -- jpg <- runReq defaultHttpConfig $ do
--     --     response <- req GET (https "pixiv.re" /: "27041254.jpg") NoReqBody bsResponse mempty
--     --     return (responseBody response :: ByteString)
--     -- Data.ByteString.writeFile "test.jpg" jpg

-- main :: IO ()
-- main = do
--     let js1 = toJSON [Plain "asd",At 123 "",Quote 0 0 0 0 [Plain "nmsl" ,Plain "cnm"]]
--     let js2 = toJSON $ object ["asd" .= ("nigger" :: Text) ,"fuck" .= object ["name" .= ("jb" :: Text) ,"age" .= (3 :: Int)]]
--     --print $ encode js2
--     print $ fmap encode $ Success js2 /@ "fuck" /@ "age"
--     print $ (eitherDecode $ encode js1 :: Either String MessageChain)
--     let code = "123"
--     print $ (eitherDecode code :: Either String StatusCode)

main :: IO ()
main = do
    let sig1 = Signal [(\x -> print 3 >> print x),(\x -> print 5 >> print x)] :: Signal Int IO
    let sig2 = sig1 `connect` (\x -> print 3 >> print x) `connect` (\x -> print 5 >> print x)
    emit sig1 2
