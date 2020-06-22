{-# LANGUAGE OverloadedStrings #-}

module Modules.PixivID(
    echoImageFromPixivID
)where

import Mirai.Api
import Mirai.Api.SendMessage
import Mirai.Types.MessageChain hiding (content)
import Mirai.Types.GroupMessage as GM
import Network.HTTP.Req
import Data.Text hiding (group)
import Data.ByteString.Lazy as BS
import Text.HTML.DOM
import Text.XML
import Text.XML.Cursor
import Text.URI
import Control.Monad.IO.Class

imagePath = "/home/xstater/mirai/plugins/MiraiAPIHTTP/images/temp.jpg" :: String

echoImageFromPixivID :: GroupMessage -> IO ()
echoImageFromPixivID groupmsg = do
    let txt = plain $ messageChain groupmsg
    let groupqq = GM.groupID $ GM.group $ sender groupmsg
    if groupqq == 795831442 then
        case txt >>= Data.Text.stripPrefix "pvid " of
            (Just pvid) -> do
                print pvid
                pic <- runReq defaultHttpConfig $ do
                    bdy <- req GET (http "pixiv.cat" /: (Data.Text.concat [pvid,".jpg"])) NoReqBody lbsResponse mempty
                    return $ responseBody bdy
                BS.writeFile imagePath pic
                runSession $ sendGroupMessage groupqq [Image "" "" "temp.jpg"] >> return ()
                return ()
            Nothing -> return ()
    else return ()
