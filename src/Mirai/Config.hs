{-# LANGUAGE OverloadedStrings #-}

module Mirai.Config(
    apiBaseURL,
    apiBasePort,
    postPort
)where

import Network.HTTP.Req


apiBaseURL = http "127.0.0.1"

apiBasePort = 23311 :: Int

postPort = 23312 :: Int
