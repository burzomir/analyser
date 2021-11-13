module Main exposing (..)

import AnalyserNode exposing (analyserNode)
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List exposing (drop, length, take)
import Slider exposing (slider)
import Visualisations.Bars exposing (bars)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { byteFrequencyData : List Float
    , range : ( Int, Int )
    , fftSize : Int
    , visualisations : List Visualisation
    , visualisationCreator : Maybe Visualisation
    }


type Msg
    = GotByteFrequencyData (List Float)
    | SetRange ( Int, Int )
    | OpenVisualisationCreator
    | CancelVisualisationCreator
    | SetVisualisationName String
    | SetVisualisationRange ( Int, Int )
    | AddVisualisation Visualisation
    | NoOp


defaultFFTSize : Int
defaultFFTSize =
    64


init : Model
init =
    { byteFrequencyData = []
    , range = ( 0, defaultFFTSize // 2 )
    , fftSize = defaultFFTSize
    , visualisations = []
    , visualisationCreator = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotByteFrequencyData values ->
            { model | byteFrequencyData = values }

        SetRange range ->
            { model | range = range }

        OpenVisualisationCreator ->
            { model
                | visualisationCreator = Just { name = "", range = ( 0, length model.byteFrequencyData ) }
            }

        CancelVisualisationCreator ->
            { model | visualisationCreator = Nothing }

        SetVisualisationName name ->
            { model | visualisationCreator = Maybe.map (\v -> { v | name = name }) model.visualisationCreator }

        SetVisualisationRange range ->
            { model | visualisationCreator = Maybe.map (\v -> { v | range = range }) model.visualisationCreator }

        AddVisualisation visualisation ->
            { model
                | visualisations = visualisation :: model.visualisations
                , visualisationCreator = Nothing
            }

        NoOp ->
            model


view : Model -> Html Msg
view model =
    div []
        [ analyserNode model.fftSize GotByteFrequencyData
        , div [] <| List.map (visualisationView model.byteFrequencyData) model.visualisations
        , button [ onClick OpenVisualisationCreator ] [ text "Add visualisation" ]
        , visualisationCreator model.byteFrequencyData model.visualisationCreator
        ]


visualisationView : List Float -> Visualisation -> Html Msg
visualisationView data visualisation =
    div []
        [ text visualisation.name
        , div [] [ bars 0 255 <| slice visualisation.range data ]
        ]


visualisationCreator : List Float -> Maybe Visualisation -> Html Msg
visualisationCreator data maybeVisualisation =
    let
        visusalisationView visualisation =
            div []
                [ div [] [ bars 0 255 data ]
                , slider 0 (length data) visualisation.range SetVisualisationRange
                , div [] [ bars 0 255 <| slice visualisation.range data ]
                , button [ onClick (AddVisualisation visualisation) ] [ text "Add" ]
                , button [ onClick CancelVisualisationCreator ] [ text "Cancel" ]
                ]
    in
    Maybe.map visusalisationView maybeVisualisation
        |> Maybe.withDefault (div [] [])


slice : ( Int, Int ) -> List a -> List a
slice ( start, end ) list =
    drop start list |> take (end - start)


type alias Visualisation =
    { name : String
    , range : ( Int, Int )
    }
