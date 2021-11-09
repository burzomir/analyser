module Slider exposing (..)

import Browser
import Html exposing (Html, div, input, node, text)
import Html.Attributes as A exposing (class, style, type_, value)
import Html.Events exposing (onInput)


main =
    Browser.sandbox { init = ( 30, 70 ), update = update, view = view }


type alias Model =
    ( Int, Int )


type Msg
    = SetValue ( Int, Int )


update : Msg -> Model -> Model
update msg ( ov1, ov2 ) =
    case msg of
        SetValue ( v1, v2 ) ->
            if v1 >= v2 then
                ( ov1, ov2 )

            else
                ( v1, v2 )


view : Model -> Html Msg
view ( v1, v2 ) =
    div [ style "position" "relative", style "height" "20px" ]
        [ sliderStyles
        , div
            [ class "slider-track"
            , style "width" <| (String.fromInt <| v2 - v1) ++ "%"
            , style "left" <| String.fromInt v1 ++ "%"
            ]
            []
        , knob 0 100 v1 (\v -> SetValue ( v, v2 ))
        , knob 0 100 v2 (\v -> SetValue ( v1, v ))
        ]


knob : Int -> Int -> Int -> (Int -> msg) -> Html msg
knob min max value onChange =
    input
        [ A.value <| String.fromInt value
        , onInput (\v -> onChange <| Maybe.withDefault 0 <| String.toInt v)
        , A.min <| String.fromInt min
        , A.max <| String.fromInt max
        , type_ "range"
        , class "slider"
        ]
        []


sliderStyles : Html msg
sliderStyles =
    node "style"
        []
        [ text sliderStylesCss ]


sliderStylesCss : String
sliderStylesCss =
    """
.slider {
    -webkit-appearance: none;
    position: absolute;
    top: 10px;
    right: 0;
    left: 0;
    bottom: 0;
    margin: 0;
    width: 100%;
    pointer-events: none;
    outline: none;
    height: 10px;
    background-color: transparent;
}
.slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    pointer-events: auto;
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background: cornflowerblue;
}

.slider::-webkit-slider-runnable-track {
    -webkit-appearance: none;
    height: 10px;
}

.slider-track {
    position: absolute;
    top: 15px;
    height: 5px;
    background: cornflowerblue; 
}
"""
