{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module Data.Aeson.Convert(
    Convertable(convert)
)where

import Data.Aeson
import Data.Text
import Data.Scientific

class Convertable a where
    convert :: Value -> Maybe a

instance Convertable Scientific where
    convert (Number n) = Just n
    convert _ = Nothing 

instance Convertable Double where
    convert (Number n) = Just $ toRealFloat n
    convert _ = Nothing

instance Convertable Float where
    convert (Number n) = Just $ toRealFloat n
    convert _ = Nothing

instance Convertable Int where
    convert (Number n) = toBoundedInteger n
    convert _ = Nothing

instance Convertable Bool where
    convert (Bool b) = Just b
    convert _ = Nothing

instance Convertable Text where
    convert (String s) = Just s
    convert _ = Nothing

instance Convertable Object where
    convert (Object o) = Just o
    convert _ = Nothing

instance Convertable Array where
    convert (Array a) = Just a
    convert _ = Nothing 