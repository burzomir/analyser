module Main exposing (..)

import AnalyserNode exposing (analyserNode)
import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (style)
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


view : Model -> Html Msg
view model =
    div []
        [ analyserNode 512 GotByteFrequencyData
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
