{-# LANGUAGE OverloadedStrings #-}

module Modules.LinkTitle(
    echoLinkTitleGroup
)where

import Mirai.Api
import Mirai.Api.SendMessage
import Mirai.Types.MessageChain hiding (content)
import Mirai.Types.GroupMessage as GM
import Network.HTTP.Req
import Data.Text
import Data.ByteString.Lazy
import Text.HTML.DOM
import Text.XML
import Text.XML.Cursor
import Text.URI
import Control.Monad.IO.Class

getHTMLTitle :: Document -> Text
getHTMLTitle doc = Data.Text.concat $ cur $/ element "head" &/ element "title" &// content
    where cur = fromDocument doc

getHTML :: Text -> IO (Maybe Document)
getHTML lnk = do
    case mkURI lnk >>= useURI of
        (Just (Left (url,opts))) -> do
            rspbdy <- runReq defaultHttpConfig $ req GET url NoReqBody lbsResponse mempty
            return $ Just $ Text.HTML.DOM.parseLBS $ responseBody rspbdy
        (Just (Right (url,opts))) -> do
            rspbdy <- runReq defaultHttpConfig $ req GET url NoReqBody lbsResponse mempty
            return $ Just $ Text.HTML.DOM.parseLBS $ responseBody rspbdy
        _ -> return Nothing

echoLinkTitleGroup :: GroupMessage -> Session ()
echoLinkTitleGroup groupmsg = do
    let (Just rawmsg) = plain $ messageChain groupmsg
    let groupid = GM.groupID $ GM.group $ GM.sender groupmsg
    if groupid == 795831442 then do
        maybeDoc <- liftIO $ getHTML rawmsg
        case maybeDoc of 
            (Just doc) -> do
                sendGroupMessage groupid [Plain $ getHTMLTitle doc]
                return ()
            Nothing -> return ()
    else return ()