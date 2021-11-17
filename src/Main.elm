module Main exposing (..)

import AnalyserNode exposing (analyserNode)
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Pages.VisualisationForm as VF
import Types.Range exposing (slice)
import Types.Visualisation exposing (Visualisation)
import Visualisations.Bars exposing (bars)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { byteFrequencyData : List Float
    , fftSize : Int
    , visualisations : List Visualisation
    , page : Page
    }


type Page
    = VisualisationList
    | VisualisationForm VF.Model


type Msg
    = GotByteFrequencyData (List Float)
    | OpenVisualisationForm
    | VisualisationFormMsg VF.Msg
    | NoOp


defaultFFTSize : Int
defaultFFTSize =
    1024


init : Model
init =
    { byteFrequencyData = []
    , fftSize = defaultFFTSize
    , visualisations = []
    , page = VisualisationList
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotByteFrequencyData values ->
            { model | byteFrequencyData = values }

        OpenVisualisationForm ->
            { model | page = VisualisationForm <| VF.init model.byteFrequencyData }

        VisualisationFormMsg visualisationFormMsg ->
            case model.page of
                VisualisationForm visualisationFormModel ->
                    let
                        ( newModel, result ) =
                            VF.update visualisationFormMsg visualisationFormModel
                    in
                    case result of
                        VF.None ->
                            { model | page = VisualisationForm newModel }

                        VF.Cancelled ->
                            { model | page = VisualisationList }

                        VF.Created visualisation ->
                            { model
                                | visualisations = visualisation :: model.visualisations
                                , page = VisualisationList
                            }

                _ ->
                    model

        NoOp ->
            model


view : Model -> Html Msg
view model =
    div []
        [ analyserNode -110 0 model.fftSize GotByteFrequencyData
        , pageView model
        ]


pageView : Model -> Html Msg
pageView model =
    case model.page of
        VisualisationList ->
            div []
                [ div [] <| List.map (visualisationView model.byteFrequencyData) model.visualisations
                , button [ onClick OpenVisualisationForm ] [ text "Add visualisation" ]
                ]

        VisualisationForm visualisationForm ->
            div [] [ Html.map VisualisationFormMsg <| VF.view model.byteFrequencyData visualisationForm ]


visualisationView : List Float -> Visualisation -> Html Msg
visualisationView data visualisation =
    div []
        [ text visualisation.name
        , div [] [ bars 0 255 <| slice visualisation.range data ]
        ]
