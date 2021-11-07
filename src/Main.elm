module Main exposing (..)

import Browser
import Html exposing (Html, div, node, text)
import Html.Events exposing (on)
import Json.Decode as D


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    Bool


type Msg
    = Initialised


init : Model
init =
    False


update : Msg -> Model -> Model
update msg _ =
    case msg of
        Initialised ->
            True


view : Model -> Html Msg
view initialised =
    div []
        [ text "Hello, World!"
        , node "analyser-test" [ on "initialised" <| D.succeed Initialised ] []
        , div []
            [ text <|
                if initialised then
                    "Intiialised!"

                else
                    ""
            ]
        ]
