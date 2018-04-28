{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Control.Monad.IO.Class
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server
import           Note
import           Data.Text
import           Data.UUID
import           Data.UUID.V4

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , ("echo/:echoparam", echoHandler)
          , ("new", newNote)
          ] <|>
    dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param


newNote :: Snap ()
newNote = do
    uuid <- liftIO $ nextRandom
    writeText $ pack $ toString uuid