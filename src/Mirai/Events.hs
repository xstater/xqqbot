{-# LANGUAGE OverloadedStrings #-}

module Mirai.Events(
    
)where

import Data.Aeson
import Data.Text
import Control.Monad.State.Lazy
import Web.Scotty
import Mirai.Config
import Mirai.Types.Events

type Mirai = StateT Events IO

-- runMirai :: Mirai () -> IO ()
-- runMirai mirai = 
