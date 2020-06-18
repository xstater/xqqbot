{-# LANGUAGE OverloadedStrings #-}

module Mirai.Types.StatusCode(
    StatusCode(
        Ok,
        AuthKeyWrong,
        BotNonExistence,
        SessionInvalid,
        SessionUnverified,
        TargetNonExistence,
        FileNonExistence,
        PermissionDenied,
        BotBeBanned,
        MessageTooLong,
        OtherError)
)where

import Data.Aeson
import Data.Text
import Data.Maybe
import Data.Scientific

data StatusCode = 
    Ok |
    AuthKeyWrong |
    BotNonExistence |
    SessionInvalid |
    SessionUnverified |
    TargetNonExistence |
    FileNonExistence |
    PermissionDenied |
    BotBeBanned |
    MessageTooLong |
    OtherError deriving (Eq,Show)

instance FromJSON StatusCode where
    parseJSON = withScientific "code" $ \s -> do
        let code = 400 `fromMaybe` (toBoundedInteger s) :: Int
        case code of
            0 -> return Ok
            1 -> return AuthKeyWrong
            2 -> return BotNonExistence
            3 -> return SessionInvalid
            4 -> return SessionUnverified
            5 -> return TargetNonExistence
            6 -> return FileNonExistence
            10 -> return PermissionDenied
            20 -> return BotBeBanned
            30 -> return MessageTooLong
            _ -> return OtherError
