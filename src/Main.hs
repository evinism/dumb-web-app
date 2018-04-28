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
          , ("new", newNote)
          ] <|>
    dir "static" (serveDirectory ".")

newNote :: Snap ()
newNote = do
    uuid <- liftIO $ nextRandom
    let filePath = "./notes/" ++ (toString uuid)
    _ <- liftIO $ writeFile filePath ""
    writeText $ pack $ toString uuid