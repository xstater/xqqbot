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
import Mirai.Api

data Events = Events {
    onBotOnline :: Signal Int Session,
    onBotOfflineActive :: Signal Int Session,
    onBotOfflineForce :: Signal Int Session,
    onBotOfflineDropped :: Signal Int Session,
    onBotRelogin :: Signal Int Session,
    onGroupMessage :: Signal GroupMessage Session,
    onFriendMessage :: Signal FriendMessage Session
} -- 7 events

emptyEvent :: Events
emptyEvent = Events (Signal []) (Signal []) (Signal []) (Signal []) (Signal []) (Signal []) (Signal [])

liftSession :: Session () -> ActionM ()
liftSession ssn = do
    res <- liftAndCatchIO $ runSession ssn
    case res of
        (Left errmsg) -> liftAndCatchIO $ putStrLn errmsg
        (Right ()) -> return ()

dispatch :: Events -> Either String EventType -> ActionM ()
dispatch _ (Left errmsg) = liftAndCatchIO $ putStrLn errmsg
dispatch events (Right (BotOnline qq)) = liftSession $ onBotOnline events `emit` qq
dispatch events (Right (BotOfflineActive qq)) = liftSession $ onBotOfflineActive events `emit` qq
dispatch events (Right (BotOfflineForce qq)) = liftSession $ onBotOfflineForce events `emit` qq
dispatch events (Right (BotOfflineDropped qq)) = liftSession $ onBotOfflineDropped events `emit` qq
dispatch events (Right (BotRelogin qq)) = liftSession $ onBotRelogin events `emit` qq
dispatch events (Right (ReceivedGroupMessage groupmsg)) = liftSession $ onGroupMessage events `emit` groupmsg
dispatch events (Right (ReceivedFriendMessage friendmsg)) = liftSession $ onFriendMessage events `emit` friendmsg
dispatch events (Right UnknownEvent) = liftAndCatchIO $ putStrLn "Unknown Event"

runMirai :: Events -> IO ()
runMirai events = 
    scotty postPort $ do
        post "/" $ do
            jsn <- body
            dispatch events $ eitherDecode jsn