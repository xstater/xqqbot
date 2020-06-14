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

type Json = Text

surround :: Char -> Char -> Json -> Json
surround cl cr txt = cl `cons` (txt `snoc` cr)

number :: (Num n,Show n) => n -> Json
number = pack . show

boolean :: Bool -> Json
boolean True = "true"
boolean False = "false"

string :: Json -> Json
string n = surround '\"' '\"' n 

object :: Json -> Json
object content = surround '{' '}' content

array :: [Json] -> Json
array xs = surround '[' ']' $ splt xs
    where
        splt :: [Json] -> Json
        splt [] = ""
        splt (x:[]) = x
        splt (x:xs) = x `append` (',' `cons` (splt xs))

(</>) :: Json -> Json -> Json
l </> r = l `append` (',' `cons` r)

(//:) :: Json -> Json -> Json
ltxt //: rtxt = ('\"' `cons` (ltxt `snoc` '\"')) `append` (':' `cons` rtxt)
