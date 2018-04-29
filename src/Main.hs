{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.IORef
import Control.Monad.State.Lazy
import Control.Lens.TH
import Snap.Core
import Snap.Http.Server
import Snap
import Data.Text

data App = App { _counter :: IORef Int }

makeLenses ''App

appInit :: SnapletInit App App
appInit = makeSnaplet "myapp" "My example application" Nothing $ do
  addRoutes [("count", countHandler)]
  ref <- liftIO $ newIORef 0
  return $ App ref

countHandler :: Handler App App ()
countHandler = method GET $ do
  ref <- gets _counter
  liftIO $ modifyIORef ref (+ 1)
  c <- liftIO $ readIORef ref
  writeText $ pack $ show c
  
main :: IO ()
main = serveSnaplet defaultConfig appInit
