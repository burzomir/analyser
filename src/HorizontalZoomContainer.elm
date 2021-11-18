module HorizontalZoomContainer exposing (horizontalZoomContainer)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
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
    = Zoom Float


update : Msg -> Model -> Model
update msg model =
    case msg of
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
    horizontalZoomContainer Zoom
        width
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


horizontalZoomContainer : (Float -> msg) -> String -> List (Html msg) -> Html msg
horizontalZoomContainer onZoom width children =
    div
        [ style "overflowX" "scroll"
        , on "wheel" (wheelDecoder onZoom)
        ]
        [ div [ style "width" width ] children ]


wheelDecoder : (Float -> msg) -> D.Decoder msg
wheelDecoder msg =
    D.map msg
        (D.field "deltaY" D.float)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
