module Slider exposing (slider)

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
update msg _ =
    case msg of
        SetValue range ->
            range


view : Model -> Html Msg
view model =
    slider 0 150 model SetValue


slider : Int -> Int -> ( Int, Int ) -> (( Int, Int ) -> msg) -> Html msg
slider min max ( v1, v2 ) onChange =
    div [ class "slider" ]
        [ sliderStyles
        , track min max v1 v2
        , knob min
            max
            v1
            (\v ->
                onChange
                    (if v >= v2 then
                        ( v1, v2 )

                     else
                        ( v, v2 )
                    )
            )
        , knob min
            max
            v2
            (\v ->
                onChange
                    (if v1 >= v then
                        ( v1, v2 )

                     else
                        ( v1, v )
                    )
            )
        ]


track : Int -> Int -> Int -> Int -> Html msg
track min max v1 v2 =
    let
        fmin =
            toFloat min

        fmax =
            toFloat max

        fv1 =
            toFloat v1

        fv2 =
            toFloat v2

        width =
            normalize fmin fmax fv2 - normalize fmin fmax fv1

        x =
            normalize fmin fmax fv1
    in
    div
        [ class "slider-track"
        , style "width" <| String.fromFloat width ++ "%"
        , style "left" <| String.fromFloat x ++ "%"
        ]
        []


normalize : Float -> Float -> Float -> Float
normalize min max value =
    (value - min) / (max - min) * 100


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
