{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import qualified Network.Wai              as Wai
import qualified Network.Wai.Handler.Warp as Warp
import qualified Servant                  as S

type API = "hello" S.:> S.Get '[ S.JSON] String

api :: S.Proxy API
api = S.Proxy

server :: S.Server API
server = return "Hello, Servant!"

app :: Wai.Application
app = S.serve api server

main :: IO ()
main = Warp.run 8080 app
