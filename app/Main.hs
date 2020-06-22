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
import Control.Monad.State.Lazy
import Mirai.Types.Events
import Mirai.Events
import Mirai.Types.GroupMessage
import Modules.LinkTitle
import Modules.PixivID
import Modules.Filter

groups :: [Int]
groups = [795831442]

friends :: [Int]
friends = []

events :: Events 
events = emptyEvent {
    onGroupMessage = Signal [filteGroup groups,echoLinkTitleGroup,echoImageFromPixivID],
    onFriendMessage = Signal [filteFriend friends]
}

main :: IO ()
main = runMirai events

