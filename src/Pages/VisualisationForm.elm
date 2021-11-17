module Pages.VisualisationForm exposing (Model, Msg, Result(..), init, update, view)

import Html exposing (Html, button, datalist, div, input, text)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick, onInput)
import List exposing (length)
import Slider exposing (slider)
import Types.FrequencyData exposing (FrequencyData)
import Types.Range exposing (Range, full, slice)
import Types.Visualisation exposing (Visualisation)
import Visualisations.Bars exposing (bars)
import Visualisations.Circle exposing (circle)


type alias Model =
    Visualisation


init : FrequencyData -> Model
init data =
    { name = "", range = full data }


type Msg
    = SetName String
    | SetRange Range
    | Create
    | Cancel


type Result
    = Created Visualisation
    | Cancelled
    | None


update : Msg -> Model -> ( Model, Result )
update msg model =
    case msg of
        SetName name ->
            ( { model | name = name }, None )

        SetRange range ->
            ( { model | range = range }, None )

        Create ->
            ( model, Created model )

        Cancel ->
            ( model, Cancelled )


view : FrequencyData -> Model -> Html Msg
view data { name, range } =
    let
        dataInRange =
            slice range data
    in
    div []
        [ text "Visualisation Form"
        , input [ type_ "text", onInput SetName, value name ] []
        , bars 0 255 data
        , slider 0 (length data) range SetRange
        , div []
            [ tile <| circle 0 255 dataInRange
            , tile <| bars 0 255 dataInRange
            ]
        , button [ onClick Create ] [ text "Create" ]
        , button [ onClick Cancel ] [ text "Cancel" ]
        ]


tile : Html msg -> Html msg
tile content =
    div
        [ style "width" "300px"
        , style "height" "300px"
        , style "display" "inline-block"
        , style "margin" "0 1em"
        ]
        [ content ]
