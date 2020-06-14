{-# LANGUAGE OverloadedStrings #-}

module Data.Aeson.Constructor(
    (//:),
    (</>),
    number,
    boolean,
    string,
    object,
    array
)where

import Data.Text
import Data.String

surround :: Char -> Char -> Text -> Text
surround cl cr txt = cl `cons` (txt `snoc` cr)

number :: (Num n,Show n) => n -> Text
number = pack . show

boolean :: Bool -> Text
boolean True = "true"
boolean False = "false"

string :: Text -> Text
string n = surround '\"' '\"' n 

object :: Text -> Text
object content = surround '{' '}' content

array :: [Text] -> Text
array xs = surround '[' ']' $ splt xs
    where
        splt :: [Text] -> Text
        splt [] = ""
        splt (x:[]) = x
        splt (x:xs) = x `append` (',' `cons` (splt xs))

(</>) :: Text -> Text -> Text
l </> r = l `append` (',' `cons` r)

(//:) :: Text -> Text -> Text
ltxt //: rtxt = ('\"' `cons` (ltxt `snoc` '\"')) `append` (':' `cons` rtxt)
