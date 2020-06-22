{-# LANGUAGE OverloadedStrings #-}

module Modules.Filter(
    filteGroup,
    filteFriend
)where

import Data.Text
import Mirai.Events
import Mirai.Types.MessageChain
import Mirai.Types.GroupMessage as GM
import Mirai.Types.FriendMessage as FM
import Mirai.Api
import Mirai.Api.SendMessage
import Control.Monad.Except

filteGroup :: [Int] -> GroupMessage -> Session ()
filteGroup grps groupmsg = do
    let groupid = GM.groupID $ GM.group $ GM.sender groupmsg
    if groupid `elem` grps then
        return ()
    else throwError $ "Received message from an unrecorded Group ID:" ++ (show groupid)

filteFriend :: [Int] -> FriendMessage -> Session ()
filteFriend fnds fndmsg = do
    let fndid = FM.qq $ FM.sender fndmsg
    if fndid `elem` fnds then
        return ()
    else throwError $ "Received message from an unrecorded qq:" ++ (show fndid)