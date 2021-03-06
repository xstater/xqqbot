{-# LANGUAGE OverloadedStrings #-}

module Mirai.Config(
    apiBaseURL,
    apiBasePort,
    postPort,
    authKey,
    botQQ,
    httpConfig
)where

import Network.HTTP.Req
import Network.HTTP.Client
import Data.Text

apiBaseURL = http "127.0.0.1"

apiBasePort = 23311 :: Int

postPort = 23312 :: Int

authKey = "INITKEYBFRTEEI2" :: Text

botQQ = 2022847429 :: Int

httpConfig = defaultHttpConfig {
    httpConfigProxy = Just $ Proxy {
        proxyHost = "127.0.0.1",
        proxyPort = 22281
    }
}
