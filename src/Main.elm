module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, div, node, text)
import Html.Events exposing (on)
import Json.Decode as D


main =
    Browser.sandbox { init = init, update = update, view = view }


type Model
    = Loading
    | Initialised (List Int)


type Msg
    = Initialise (List Int)


init : Model
init =
    Loading


update : Msg -> Model -> Model
update msg _ =
    case msg of
        Initialise values ->
            Initialised values


decoder : D.Decoder (List Int)
decoder =
    D.field "detail" <| D.list D.int


view : Model -> Html Msg
view model =
    div []
        [ text "Hello, World!"
        , node "analyser-test" [ on "initialised" <| D.map Initialise decoder ] []
        , div []
            [ text <|
                case model of
                    Loading ->
                        ""

                    Initialised values ->
                        "Initialised!" ++ (String.join " " <| List.map String.fromInt values)
            ]
        ]
