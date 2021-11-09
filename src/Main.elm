module Main exposing (..)

import Browser
import Html exposing (Html, div, node, text)
import Html.Attributes exposing (property, style)
import Html.Events exposing (on)
import Json.Decode as D
import Json.Encode as E


main =
    Browser.sandbox { init = init, update = update, view = view }


type Model
    = Loading
    | Initialised (List Float)


type Msg
    = Initialise (List Float)


init : Model
init =
    Loading


update : Msg -> Model -> Model
update msg _ =
    case msg of
        Initialise values ->
            Initialised values


decoder : D.Decoder (List Float)
decoder =
    D.field "detail" <| D.list D.float


view : Model -> Html Msg
view model =
    div []
        [ text "Hello, World!"
        , node "analyser-test"
            [ on "initialised" <| D.map Initialise decoder
            , property "fftSize" <| E.int 512
            ]
            []
        , div [] <|
            case model of
                Initialised data ->
                    [ visualisation data ]

                _ ->
                    []
        ]


visualisation : List Float -> Html Msg
visualisation data =
    div
        [ style "display" "flex"
        , style "height" "300px"
        , style "align-items" "flex-end"
        ]
    <|
        List.map bar data


bar : Float -> Html Msg
bar height =
    div
        [ style "height" <| String.fromFloat (height / 255 * 100) ++ "%"
        , style "flex" "1"
        , style "background" "cornflowerblue"
        ]
        []
