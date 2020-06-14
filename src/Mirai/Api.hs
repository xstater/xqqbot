{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RankNTypes #-}

module Mirai.Api(
    ErrorCode,
    Session,
    runSession,
    --version
    sendFriendMessage,
    -- sendTempMessage,
    sendGroupMessage,
    sendImageMessage,
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
import Data.Text.Encoding
import Data.Aeson hiding (object)
import Data.Aeson.Constructor
import Data.Aeson.Cursor
import Data.Aeson.Convert
import Data.ByteString
import Network.HTTP.Req
import Text.URI
import Mirai.MessageChain

baseURL = http "127.0.0.1"
basePort = 23311

reqPost path body = do
    response <- req POST (baseURL /: path) (ReqBodyBs $ encodeUtf8 body) jsonResponse (port basePort)
    return (responseBody response :: Maybe Value)

auth :: Text -> IO (Maybe Text)
auth key = do
    jsn <- runReq defaultHttpConfig $ reqPost "auth" (object $ "authKey" //: (string key))
    return $ jsn /@ "session" >>= convert

data ErrorCode = 
    AuthKeyWrong |
    BotNonExistence |
    SessionInvalid |
    SessionUnverified |
    TargetNonExistence |
    FileNonExistence |
    PermissionDenied |
    BotBeBanned |
    MessageTooLong |
    OtherError String deriving (Eq,Ord,Show)

type Session = ReaderT (Text,Int) (ExceptT ErrorCode IO)

instance MonadHttp Session where
    handleHttpException err = throwError $ OtherError $ show err

runSession :: Text -> Int -> Session () -> IO (Either ErrorCode ())
runSession key qq session = do
    let session_ = verify >> session >> release
    sessionIDMaybe <- auth key
    case sessionIDMaybe of
        (Just sessionID) -> do
            let except = runReaderT session_ (sessionID,qq)
            runExceptT except
        Nothing -> return $ Left $ OtherError "Make session failed"

analysisCode :: Maybe Value -> Session ()
analysisCode jsn = case (jsn /@ "code") >>= convert :: Maybe Int of
    (Just 0) -> return ()
    (Just 1) -> throwError AuthKeyWrong
    (Just 2) -> throwError BotNonExistence
    (Just 3) -> throwError SessionInvalid
    (Just 4) -> throwError SessionUnverified
    (Just 5) -> throwError TargetNonExistence
    (Just 6) -> throwError FileNonExistence
    (Just 10) -> throwError PermissionDenied
    (Just 20) -> throwError BotBeBanned
    (Just 30) -> throwError MessageTooLong
    _ -> throwError $ OtherError "Unknow error code"

verify :: Session ()
verify = do
    (sid,qq) <- ask
    jsn <- reqPost "verify" (object (
        ("sessionKey" //: sid) </>
        ("qq" //: number qq)))
    analysisCode jsn

release :: Session ()
release = do
    (sid,qq) <- ask
    jsn <- reqPost "release" (object (
        ("sessionKey" //: sid) </>
        ("qq" //: number qq)))
    analysisCode jsn

sendFriendMessage :: Int -> MessageChain -> Session ()
sendFriendMessage qq msgc = do
    (sid,_) <- ask
    jsn <- reqPost "sendFriendMessage" (object (
        ("sessionKey" //: sid) </>
        ("target" //: number qq) </>
        ("messageChain" //: toJsonTextChain msgc)))
    analysisCode jsn

sendGroupMessage :: Int -> MessageChain -> Session ()
sendGroupMessage qq msgc = do
    (sid,_) <- ask
    jsn <- reqPost "sendGroupMessage" (object (
        ("sessionKey" //: sid) </>
        ("target" //: number qq) </>
        ("messageChain" //: toJsonTextChain msgc)))
    analysisCode jsn

sendImageMessage :: Int -> Text -> Session ()
sendImageMessage qq url = do
    (sid,_) <- ask
    jsn <- reqPost "sendImageMessage" (object (
        ("sessionKey" //: sid) </>
        ("target" //: number qq) </>
        ("urls" //: array [string url])))
    return ()
