{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Mirai.Api(
    -- version
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
import Control.Monad.Reader
import Control.Monad.Except
import Data.Text
import Data.Aeson
import Data.Aeson.Constructor
import Network.HTTP.Req

type Session m a = ExceptT Text (ReaderT Text m) a

-- instance MonadHttp (Session m) where
--     handleHttpException err = 

-- runSession :: MonadIO m => Text -> Session m a -> m (Either Text a)
-- runSession = undefined