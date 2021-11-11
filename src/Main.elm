module Main exposing (..)

import Browser
import Html exposing (Html, div, node, text)
import Html.Attributes exposing (property, style)
import Html.Events exposing (on)
import Json.Decode as D
import Json.Encode as E
import Slider exposing (slider)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { byteFrequencyData : List Float }


type Msg
    = GotByteFrequencyData (List Float)
    | NoOp


init : Model
init =
    { byteFrequencyData = [] }


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotByteFrequencyData values ->
            { model | byteFrequencyData = values }

        NoOp ->
            model


decoder : D.Decoder (List Float)
decoder =
    D.field "detail" <| D.list D.float


view : Model -> Html Msg
view model =
    div []
        [ node "analyser-node"
            [ on "GotByteFrequencyData" <| D.map GotByteFrequencyData decoder
            , property "fftSize" <| E.int 512
            ]
            []
        , div [] [ visualisation model.byteFrequencyData ]
        , slider 0 512 ( 10, 100 ) (\_ -> NoOp)
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
