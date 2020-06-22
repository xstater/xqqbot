{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RankNTypes #-}

module Mirai.Api(
    Session,
    runSession
)where

import Control.Monad
import Control.Monad.IO.Class
import Control.Exception
import Control.Monad.State.Lazy
import Control.Monad.Except
import Data.Text
import Data.Text.Encoding
import Data.Aeson
import Data.ByteString
import Network.HTTP.Req
import Text.URI
import Mirai.Types.MessageChain
import Mirai.Config
import Mirai.Types.StatusCode

type Session = StateT (Text,Int) (ExceptT String IO)

instance MonadHttp Session where
    handleHttpException = throwError . show

runSession :: Session () -> IO (Either String ())
runSession session = do
    let session' = auth authKey >>= \s -> put (s,botQQ) >> verify >> session >> release
    let except = evalStateT session' ("",0) 
    runExceptT except


data AuthResponse = AuthResponse StatusCode Text deriving (Eq,Show)

instance FromJSON AuthResponse where
    parseJSON = withObject "AuthResponse" $ \o -> AuthResponse `fmap` (o .: "code") <*> (o .: "session")

auth :: Text -> Session Text
auth key = do
    jsn <- req POST (apiBaseURL /: "auth") (ReqBodyJson $ object ["authKey" .= key]) jsonResponse (port apiBasePort)
    let (AuthResponse c s) = responseBody jsn
    case c of
        Ok -> return s
        _ -> throwError $ show c

data VerifyResponse = VerifyResponse StatusCode Text deriving (Eq,Show)
instance FromJSON VerifyResponse where
    parseJSON = withObject "VerifyResponse" $ \o -> VerifyResponse `fmap` (o .: "code") <*> (o .: "msg")

verify :: Session ()
verify = do
    (sid,qq) <- get
    jsn <- req POST (apiBaseURL /: "verify") (ReqBodyJson $ object ["sessionKey" .= sid,"qq" .= qq]) jsonResponse (port apiBasePort)
    let (VerifyResponse c m) = responseBody jsn
    case c of
        Ok -> return ()
        _ -> throwError $ Data.Text.unpack m

type ReleaseResponse = VerifyResponse

release :: Session ()
release = do
    (sid,qq) <- get
    jsn <- req POST (apiBaseURL /: "release") (ReqBodyJson $ object ["sessionKey" .= sid,"qq" .= qq]) jsonResponse (port apiBasePort)
    let (VerifyResponse c m) = responseBody jsn
    case c of
        Ok -> return ()
        _ -> throwError $ Data.Text.unpack m