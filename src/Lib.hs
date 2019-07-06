{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Lib
  ( runDemo
  ) where


import Data.Text (pack, Text(..))
import Network.VaultTool (vaultHealth, VaultHealth (..), VaultAddress (..))
import Say (say)

vaultURL :: VaultAddress
vaultURL = VaultAddress "http://127.0.0.1:8200"

runDemo :: IO ()
runDemo = do
  say "check vault status.."
  (status :: VaultHealth) <- vaultHealth vaultURL
  say $ pack $ show status