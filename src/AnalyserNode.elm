module AnalyserNode exposing (analyserNode)

import Html exposing (Html, node)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Decode as D
import Json.Encode as E


decoder : D.Decoder (List Float)
decoder =
    D.field "detail" <| D.list D.float


type alias FFTSize =
    Int


type alias MinDecibels =
    Int


type alias MaxDecibels =
    Int


type alias GotByteFrequencyData msg =
    List Float -> msg


analyserNode : MinDecibels -> MaxDecibels -> FFTSize -> GotByteFrequencyData msg -> Html msg
analyserNode minDecibels maxDecibels fftSize gotByteFrequencyData =
    node "analyser-node"
        [ on "GotByteFrequencyData" <| D.map gotByteFrequencyData decoder
        , property "fftSize" <| E.int fftSize
        , property "minDecibels" <| E.int minDecibels
        , property "maxDecibels" <| E.int maxDecibels
        ]
        []
