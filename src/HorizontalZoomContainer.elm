module HorizontalZoomContainer exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on, onClick)
import Json.Decode as D


type alias Model =
    { count : Int, width : Float }


minWidth : Float
minWidth =
    100


initialModel : Model
initialModel =
    { count = 0, width = 100 }


type Msg
    = Increment
    | Decrement
    | Zoom Float


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        Zoom delta ->
            let
                newWidth =
                    model.width + delta
            in
            { model
                | width =
                    if newWidth > minWidth then
                        newWidth

                    else
                        minWidth
            }


view : Model -> Html Msg
view model =
    let
        width =
            String.fromFloat model.width ++ "%"
    in
    container width
        [ div [ style "display" "flex" ] <| List.repeat 10 tile ]


tile : Html Msg
tile =
    div
        [ style "background" "cornflowerblue"
        , style "margin" "1em"
        , style "height" "100px"
        , style "flex" "1"
        ]
        []


container : String -> List (Html Msg) -> Html Msg
container width children =
    div
        [ style "overflowX" "scroll"
        , on "wheel" wheelDecoder
        ]
        [ div [ style "width" width ] children ]


wheelDecoder : D.Decoder Msg
wheelDecoder =
    D.map Zoom
        (D.field "deltaY" D.float)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
