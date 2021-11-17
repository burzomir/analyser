module Visualisations.Circle exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import List exposing (foldl)


circle : Float -> Float -> List Float -> Html msg
circle minValue maxValue data =
    let
        value =
            foldl max 0 data

        normalizedValue =
            (value - minValue) / (maxValue - minValue)
    in
    div
        [ style "height" "300px"
        , style "width" "300px"
        , style "transform" <| "scale(" ++ String.fromFloat normalizedValue ++ ")"
        , style "background" "cornflowerblue"
        , style "border-radius" "50%"
        ]
        []
