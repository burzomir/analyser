module Slider exposing (..)

import Browser
import Html exposing (Attribute, Html, div, input, node, text)
import Html.Attributes as A exposing (attribute, class, style, type_, value)
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
        , input (List.append sliderAttrs [ value <| String.fromInt v1, onInput (\v -> SetValue ( String.toInt v |> Maybe.withDefault 0, v2 )) ]) []
        , input (List.append sliderAttrs [ value <| String.fromInt v2, onInput (\v -> SetValue ( v1, String.toInt v |> Maybe.withDefault 0 )) ]) []
        ]


sliderAttrs : List (Attribute msg)
sliderAttrs =
    [ A.min "0"
    , A.max "100"
    , type_ "range"
    , class "slider"
    ]


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
