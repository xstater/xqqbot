{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Aeson hiding (object)
import Data.Aeson.Cursor
import Data.Aeson.Constructor

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

main :: IO ()
main = do
    print $ "asd" //: (number 3)
    print $ object $ (
        ("name" //: string "jack") </>
        ("age"  //: number 1) </>
        ("array"//: (array $ number `fmap` [1..10])))