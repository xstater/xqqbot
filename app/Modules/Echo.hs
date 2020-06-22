{-# LANGUAGE OverloadedStrings #-}

module Modules.Echo(
    echoGroup
)where

import Data.Text
import Mirai.Events
import Mirai.Types.MessageChain
import Mirai.Types.GroupMessage as GM
import Mirai.Api
import Mirai.Api.SendMessage

echoGroup :: GroupMessage -> IO ()
echoGroup groupmsg = do
    s <- runSession $ do
        let (Just rawmsg) = plain $ messageChain groupmsg
        let groupid = GM.groupID $ GM.group $ sender groupmsg
        if groupid == 795831442 then do
            sendGroupMessage groupid [Plain rawmsg]
            return ()
        else return ()
    return ()