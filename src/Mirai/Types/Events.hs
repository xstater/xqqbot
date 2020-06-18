{-# LANGUAGE OverloadedStrings #-}

module Mirai.Types.Events(
    Events(
        Events,
        onBotOnline,
        onBotOfflineActive,
        onBotOfflineForce,
        onBotOfflineDropped,
        onBotRelogin,
        onGroupMessage,
        onFriendMessage
    )
)where

import Data.Aeson
import Data.Text
import Control.SignalSlot
import Mirai.Types.GroupMessage as GM
import Mirai.Types.FriendMessage as FM

data Events = Events {
    onBotOnline :: Signal Int IO,
    onBotOfflineActive :: Signal Int IO,
    onBotOfflineForce :: Signal Int IO,
    onBotOfflineDropped :: Signal Int IO,
    onBotRelogin :: Signal Int IO,
    onGroupMessage :: Signal GroupMessage IO,
    onFriendMessage :: Signal FriendMessage IO
}

instance FromJSON Events where
    parseJSON = undefined