module Main exposing (..)

import AnalyserNode exposing (analyserNode)
import Browser
import Html exposing (Html, div)
import List exposing (drop, length, take)
import Slider exposing (slider)
import Visualisations.Bars exposing (bars)


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
        , div [] [ bars 0 255 model.byteFrequencyData ]
        , slider 0 (length model.byteFrequencyData) model.range SetRange
        , div [] [ bars 0 255 <| slice model.range model.byteFrequencyData ]
        ]


slice : ( Int, Int ) -> List a -> List a
slice ( start, end ) list =
    drop start list |> take (end - start)
