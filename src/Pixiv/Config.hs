{-# LANGUAGE OverloadedStrings #-}

module Pixiv.Config(
    httpConfig
)where

import Network.HTTP.Req
import Network.HTTP.Client
import Data.Text

authKey = "Bearer WHDWCGnwWA2C8PRfQSdXJxjXp0G6ULRaRkkd6t5B6h8" :: Text

httpConfig = defaultHttpConfig {
    httpConfigProxy = Just $ Proxy {
        proxyHost = "127.0.0.1",
        proxyPort = 22281
    }
}