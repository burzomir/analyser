module Visualisations.Bars exposing (bars)

import Html exposing (Html, div)
import Html.Attributes exposing (style)


bars : Float -> Float -> List Float -> Html msg
bars minValue maxValue values =
    div
        [ style "display" "flex"
        , style "height" "300px"
        , style "align-items" "flex-end"
        ]
    <|
        List.map (\value -> bar minValue maxValue value) values


bar : Float -> Float -> Float -> Html msg
bar minValue maxValue value =
    let
        normalizedValue =
            (value - minValue) / (maxValue - minValue) * 100
    in
    div
        [ style "height" <| String.fromFloat normalizedValue ++ "%"
        , style "flex" "1"
        , style "background" "cornflowerblue"
        , style "margin" "0 1px"
        ]
        []
