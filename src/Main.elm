module Main exposing (..)

import AnalyserNode exposing (analyserNode)
import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import List exposing (length)
import Slider exposing (slider)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { byteFrequencyData : List Float
    , range : ( Int, Int )
    , fftSize : Int
    }


type Msg
    = GotByteFrequencyData (List Float)
    | SetRange ( Int, Int )
    | NoOp


defaultFFTSize : Int
defaultFFTSize =
    64


init : Model
init =
    { byteFrequencyData = []
    , range = ( 0, defaultFFTSize // 2 )
    , fftSize = defaultFFTSize
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotByteFrequencyData values ->
            { model | byteFrequencyData = values }

        SetRange range ->
            { model | range = range }

        NoOp ->
            model


view : Model -> Html Msg
view model =
    div []
        [ analyserNode model.fftSize GotByteFrequencyData
        , div [] [ visualisation model.byteFrequencyData ]
        , slider 0 (length model.byteFrequencyData) model.range SetRange
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
