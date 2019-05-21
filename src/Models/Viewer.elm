module Models.Viewer exposing (Viewer, cred, decoder, minPasswordChars, store, username)

import Api exposing (Cred)

import Models.Email exposing (Email)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, required)
import Json.Encode as Encode exposing (Value)
import Models.Username as Username exposing (Username)


type Viewer
    = Viewer Cred


cred : Viewer -> Cred
cred (Viewer val) =
    val


username : Viewer -> Username
username (Viewer val) =
    Api.username val


minPasswordChars : Int
minPasswordChars =
    6


decoder : Decoder (Cred -> Viewer)
decoder =
    Decode.succeed Viewer


store : Viewer -> Cmd msg
store (Viewer credVal) =
    Api.storeCredWith
        credVal
