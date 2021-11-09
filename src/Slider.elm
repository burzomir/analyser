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
    div [ class "slider" ]
        [ sliderStyles
        , track v1 v2
        , knob 0 100 v1 (\v -> SetValue ( v, v2 ))
        , knob 0 100 v2 (\v -> SetValue ( v1, v ))
        ]


slider : Int -> Int -> ( Int, Int ) -> (( Int, Int ) -> msg) -> Html msg
slider min max ( v1, v2 ) onChange =
    div [ class "slider" ]
        [ sliderStyles
        , track v1 v2
        , knob min max v1 (\v -> onChange ( v, v2 ))
        , knob min max v2 (\v -> onChange ( v1, v ))
        ]


track : Int -> Int -> Html msg
track v1 v2 =
    div
        [ class "slider-track"
        , style "width" <| (String.fromInt <| v2 - v1) ++ "%"
        , style "left" <| String.fromInt v1 ++ "%"
        ]
        []


knob : Int -> Int -> Int -> (Int -> msg) -> Html msg
knob min max value onChange =
    input
        [ A.value <| String.fromInt value
        , onInput (\v -> onChange <| Maybe.withDefault 0 <| String.toInt v)
        , A.min <| String.fromInt min
        , A.max <| String.fromInt max
        , type_ "range"
        , class "slider-knob"
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
    position: relative;
    height: 20px;
}

.slider-knob {
    -webkit-appearance: none;
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
    bottom: 0;
    margin: 0;
    width: 100%;
    pointer-events: none;
    outline: none;
    height: 20px;
    background-color: transparent;
}
.slider-knob::-webkit-slider-thumb {
    -webkit-appearance: none;
    pointer-events: auto;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: cornflowerblue;
}

.slider-knob::-webkit-slider-runnable-track {
    -webkit-appearance: none;
    height: 20px;
}

.slider-track {
    position: absolute;
    top: 6px;
    height: 8px;
    background: cornflowerblue; 
}
"""
