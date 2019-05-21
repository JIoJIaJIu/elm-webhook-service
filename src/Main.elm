module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import List
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Url exposing (Url)

import Api
import Models.Viewer as Viewer


type alias Model =
    {}

init : Maybe viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    ( {}, Cmd.none )


type Msg
    = NoOp
    | ChangedUrl Url
    | UrlRequest Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Elm webhook app"
    , body = [
        div []
            [ img [ src "/logo.svg" ] []
              , h1 [] [ text "Your Elm App is working!" ]
            ]
      ]
    }


main =
    Api.application Viewer.decoder
      { init = init
      , onUrlChange = ChangedUrl
      , onUrlRequest = UrlRequest
      , subscriptions = \_ -> Sub.none
      , update = update
      , view = view
      }
