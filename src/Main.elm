module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Url exposing (Url)

import List
import Tuple

import Api
import Models.Viewer as Viewer exposing (Viewer)
import Page.Register as Register
import Route exposing (Route)
import Session exposing (Session)


type Model =
    Redirect Session
    | Register Register.Model
    | Login {}
    | Empty


type Msg
    = NoOp
    | ChangedUrl Url
    | UrlRequest Browser.UrlRequest
    | GotRegisterMsg Register.Msg


init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    let
        session = Session.fromViewer navKey maybeViewer
    in
    case Route.fromUrl url of
        Just Route.Register ->
            Tuple.mapFirst (\_ -> Register <| (Register.init session |> Tuple.first)) (Nothing, Cmd.none)
        Just _ ->
            (Empty, Cmd.none)
        Nothing ->
            (Empty, Cmd.none)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (msg, model) of
        ( NoOp, _ ) -> ( model, Cmd.none )
        ( ChangedUrl url, _) -> (model, Cmd.none)
        ( UrlRequest request, _) -> (model, Cmd.none)
        ( GotRegisterMsg _, _) -> (model, Cmd.none)


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )

view : Model -> Document Msg
view model =
    case model of
        Register register ->
            let
                {title, content} = Register.view register
            in
            { title = title
            , body = List.map (Html.map GotRegisterMsg) content
            }
        Login register ->
            { title = "Elm webhook app"
            , body = [
                div []
                    [ img [ src "/logo.svg" ] []
                      , h1 [] [ text "Your Elm App is working!" ]
                    ]
              ]
            }
        Empty ->
            { title = "Elm webhook app"
            , body = [
                div []
                    [ img [ src "/logo.svg" ] []
                      , h1 [] [ text "Your Elm App is working!" ]
                    ]
              ]
            }
        Redirect _ ->
            { title = "Redirect"
            , body = []
            }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Register register ->
            Sub.map GotRegisterMsg (Register.subscriptions register)
        Login register ->
            Sub.none
        Redirect _ ->
            Sub.none
        Empty ->
            Sub.none


main =
    Api.application Viewer.decoder
      { init = init
      , onUrlChange = ChangedUrl
      , onUrlRequest = UrlRequest
      , subscriptions = \_ -> Sub.none
      , update = update
      , view = view
      }
