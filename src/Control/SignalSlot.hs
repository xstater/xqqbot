{-# LANGUAGE OverloadedStrings #-}

module Control.SignalSlot(
    Signal (Signal,callbacks),
    connect,
    emit
)where

import Control.Monad

data Signal e m = Signal {
    callbacks :: [e -> m ()]
}

connect :: Monad m => Signal e m -> (e -> m ()) -> Signal e m
(Signal cbks) `connect` func = Signal $ func : cbks

runAll :: Monad m => [e -> m ()] -> e -> m ()
runAll [] _ = return ()
runAll (x:xs) e = x e >> runAll xs e

emit :: Monad m => Signal e m -> e -> m ()
emit (Signal xs) e = runAll xs e
