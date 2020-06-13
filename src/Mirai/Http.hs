{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Mirai.Http(
    -- version
    -- auth,
    -- verify,
    -- release,
    -- sendFriendMessage,
    -- sendTempMessage,
    -- sendGroupMessage,
    -- sendImageMessage,
    -- uploadImage,
    -- recall,
    -- fetchMessage,
    -- fetchLatestMessage,
    -- peekMessage,
    -- peekLatestMessage,
    -- messageFromId,
    -- countMessage,
    -- friendList,
    -- groupList,
    -- memberList,
    -- muteAll,
    -- unmuteAll,
    -- mute,
    -- unmute,
    -- kick,
    -- quit,
    -- groupConfig,
    -- memberInfo,
    -- config
)where

import Control.Monad
import Control.Monad.IO.Class
import Control.Exception
import Data.Text
import Data.Aeson
import Network.HTTP.Req

baseURL = http "127.0.0.1:23311"
