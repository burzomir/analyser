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

        finalValue =
            if normalizedValue > 0.6 then
                normalizedValue

            else
                0
    in
    div
        [ style "height" "300px"
        , style "width" "300px"
        , style "transform" <| "scale(" ++ String.fromFloat finalValue ++ ")"
        , style "background" "cornflowerblue"
        , style "border-radius" "50%"
        , style "transition" "transform ease-out 200ms"
        ]
        []
