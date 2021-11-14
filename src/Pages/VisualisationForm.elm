module Pages.VisualisationForm exposing (Model, Msg, Result(..), init, update, view)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import List exposing (length)
import Slider exposing (slider)
import Types.FrequencyData exposing (FrequencyData)
import Types.Range exposing (Range, full, slice)
import Types.Visualisation exposing (Visualisation)
import Visualisations.Bars exposing (bars)


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
    div []
        [ text "Visualisation Form"
        , input [ type_ "text", onInput SetName, value name ] []
        , bars 0 255 data
        , slider 0 (length data) range SetRange
        , bars 0 255 (slice range data)
        , button [ onClick Create ] [ text "Create" ]
        , button [ onClick Cancel ] [ text "Cancel" ]
        ]
