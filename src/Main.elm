module Main exposing (..)

import AnalyserNode exposing (analyserNode)
import Browser
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (value, type_)
import Html.Events exposing (onClick, onInput)
import Pages.VisualisationForm as VF
import Types.Range exposing (slice)
import Types.Visualisation exposing (Visualisation)
import Visualisations.Bars exposing (bars)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { byteFrequencyData : List Float
    , previousByteFrequencyData : List Float
    , frameCount : Int
    , fftSize : Int
    , visualisations : List Visualisation
    , page : Page
    , diffFrequency : Int
    }


type Page
    = VisualisationList
    | VisualisationForm VF.Model


type Msg
    = GotByteFrequencyData (List Float)
    | OpenVisualisationForm
    | VisualisationFormMsg VF.Msg
    | SetDiffFrequency Int
    | NoOp


defaultFFTSize : Int
defaultFFTSize =
    512


init : Model
init =
    { byteFrequencyData = []
    , previousByteFrequencyData = []
    , fftSize = defaultFFTSize
    , visualisations = []
    , page = VisualisationForm <| VF.init []
    , frameCount = 1
    , diffFrequency = 10
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotByteFrequencyData values ->
            { model
                | frameCount = model.frameCount + 1
                , byteFrequencyData = values
                , previousByteFrequencyData =
                    if modBy model.frameCount model.diffFrequency == 0 then
                        model.byteFrequencyData

                    else
                        model.previousByteFrequencyData
            }

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

        SetDiffFrequency diffFrequency ->
            { model | diffFrequency = diffFrequency }

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
            div []
                [ Html.map VisualisationFormMsg <| VF.view model.previousByteFrequencyData model.byteFrequencyData visualisationForm
                , label [] [ text "Diff Frequency" ]
                , input
                    [ onInput <| \v -> String.toInt v |> Maybe.map SetDiffFrequency |> Maybe.withDefault (SetDiffFrequency 0)
                    , value <| String.fromInt model.diffFrequency
                    , type_ "number"
                    ]
                    []
                ]


visualisationView : List Float -> Visualisation -> Html Msg
visualisationView data visualisation =
    div []
        [ text visualisation.name
        , div [] [ bars 0 255 <| slice visualisation.range data ]
        ]
