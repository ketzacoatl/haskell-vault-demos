{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Lib
  ( runDemo
  ) where

import Data.Aeson

import Data.Text
  ( pack
  , Text(..)
  )

import Network.VaultTool
  ( connectToVault
  , vaultHealth
  , vaultListRecursive
  , vaultWrite
  , VaultAddress (..)
  , VaultAuthToken (..)
  , VaultHealth (..)
  , VaultMountedPath (..)
  , VaultSearchPath (..)
  , VaultSecretPath (..)
  )

import Say (say)

vaultURL :: VaultAddress
vaultURL = VaultAddress "http://127.0.0.1:8200"

vaultToken :: VaultAuthToken
vaultToken = VaultAuthToken "xyzrootoken" -- TODO: pull this from a envvar

kvSecretMount :: VaultMountedPath
kvSecretMount = VaultMountedPath "secret"

mySecretKey :: VaultSearchPath
mySecretKey = VaultSearchPath "my-secret"

mySecretPath :: VaultSecretPath
mySecretPath = VaultSecretPath (kvSecretMount, mySecretKey)

data Contact = Contact
       { name :: Text
       , email :: Text
       , message :: Text
       } deriving Show

instance ToJSON Contact where
    toJSON (Contact name email message) = object
        [ "name" .= name
        , "email" .= email
        , "message" .= message
        ]

data VaultContact = VaultContact
       { vaultData :: Contact
       } deriving Show
       
instance ToJSON VaultContact where
    toJSON (VaultContact vaultData) = object [ "data" .= vaultData ]

msgOne :: Contact
msgOne = Contact {name = "Alice", email = "alice@yahoo.com", message = "hi, here is my message"}

secretOne :: VaultContact
secretOne = VaultContact {vaultData = msgOne}

runDemo :: IO ()
runDemo = do
  say "check vault status.."
  (status :: VaultHealth) <- vaultHealth vaultURL
  say $ pack $ show status
  vaultConnection <- connectToVault vaultURL vaultToken
  vaultWrite vaultConnection mySecretPath (toJSON secretOne)