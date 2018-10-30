{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main where

-- was looking at
-- https://github.com/bitc/hs-vault-tool/blob/master/vault-tool-server/test/test.hs

--import Lib
import Data.Aeson
import Data.Text
import Network.VaultTool
import GHC.Generics (Generic)

data B64toEncrypt = B64toEncrypt { plaintext :: Text }
                    deriving (Show, Generic)

instance FromJSON B64toEncrypt
instance ToJSON B64toEncrypt

main :: IO ()
main = do
  let token = VaultAuthToken "4vRFx15zZn4WVqeoYxCa4U5I"
  let addr = VaultAddress ("http://127.0.0.1:8200" :: Text)
  let b64json = B64toEncrypt { plaintext = "dGhlIHF1aWNrIGJyb3duIGZveA=="}
  putStrLn "Will now connect to Vault!"
  conn <- connectToVault addr token
  vaultWrite conn (VaultSecretPath "secret/data/hsv") (object ["data" .= (object ["A" .= 'a', "B" .= 'b'])])
  vaultWrite conn (VaultSecretPath "transit/encrypt/hsv") b64json
  keys <- vaultList conn (VaultSecretPath "secret/")
  print keys
  putStrLn "DONE!"
