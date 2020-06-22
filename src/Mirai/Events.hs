{-# LANGUAGE OverloadedStrings #-}

module Mirai.Events(
    Events(
        Events,
        onBotOnline,
        onBotOfflineActive,
        onBotOfflineForce,
        onBotOfflineDropped,
        onBotRelogin,
        onGroupMessage,
        onFriendMessage),
    emptyEvent,
    runMirai
)where

import Data.Aeson
import Data.Text
import Control.Monad.Reader
import Control.SignalSlot
import Web.Scotty hiding (get,put)
import Mirai.Config
import Mirai.Types.Events
import Mirai.Types.FriendMessage
import Mirai.Types.GroupMessage

data Events = Events {
    onBotOnline :: Signal Int IO,
    onBotOfflineActive :: Signal Int IO,
    onBotOfflineForce :: Signal Int IO,
    onBotOfflineDropped :: Signal Int IO,
    onBotRelogin :: Signal Int IO,
    onGroupMessage :: Signal GroupMessage IO,
    onFriendMessage :: Signal FriendMessage IO
} -- 7 events

emptyEvent :: Events
emptyEvent = Events (Signal []) (Signal []) (Signal []) (Signal []) (Signal []) (Signal []) (Signal []) 

dispatch :: Events -> Either String EventType -> ActionM ()
dispatch _ (Left errmsg) = liftAndCatchIO $ putStrLn errmsg
dispatch events (Right (BotOnline qq)) = liftAndCatchIO $ onBotOnline events `emit` qq
dispatch events (Right (BotOfflineActive qq)) = liftAndCatchIO $ onBotOfflineActive events `emit` qq
dispatch events (Right (BotOfflineForce qq)) = liftAndCatchIO $ onBotOfflineForce events `emit` qq
dispatch events (Right (BotOfflineDropped qq)) = liftAndCatchIO $ onBotOfflineDropped events `emit` qq
dispatch events (Right (BotRelogin qq)) = liftAndCatchIO $ onBotRelogin events `emit` qq
dispatch events (Right (ReceivedGroupMessage groupmsg)) = liftAndCatchIO $ onGroupMessage events `emit` groupmsg
dispatch events (Right (ReceivedFriendMessage friendmsg)) = liftAndCatchIO $ onFriendMessage events `emit` friendmsg
dispatch events (Right UnknownEvent) = liftAndCatchIO $ putStrLn "Unknown Event"

runMirai :: Events -> IO ()
runMirai events = 
    scotty postPort $ do
        post "/" $ do
            jsn <- body
            dispatch events $ eitherDecode jsn