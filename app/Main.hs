{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Aeson
import Data.Aeson.Cursor

-- main :: IO ()
-- main = scotty 23312 $ do
--     post "/" $ do
--         bodyData <- body
--         liftAndCatchIO $ print bodyData

main :: IO ()
main = do
    let jsn = decode "{\"info\":{\"name\":\"fuck\",\"age\":123}}" :: Maybe Value
    print $ jsn /@ "info" /@ "name"
    print $ jsn /@ "info" /@ "age"
    print $ jsn /@ "nmsl" /@ "shit"
    print $ jsn /@ "info" /@ "fuck"