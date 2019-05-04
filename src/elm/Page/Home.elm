module Page.Home exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Context exposing (Context)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Ports
import Route
import Views.Icons as Icons



-- Model


type alias Model =
    { context : Context
    , workoutInProgress : Bool
    }


type Msg
    = ReceiveWorkoutInProgress Bool



-- Init


init : Context -> ( Model, Cmd Msg )
init context =
    ( initialModel context
    , Ports.workoutInProgress ()
    )


initialModel : Context -> Model
initialModel context =
    { context = context
    , workoutInProgress = False
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveWorkoutInProgress inProgress ->
            ( { model | workoutInProgress = inProgress }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.receiveWorkoutInProgress ReceiveWorkoutInProgress



-- View


view : Model -> Html Msg
view model =
    div []
        [ goToWorkout model
        , p [ class "white headline pointer mb4 bg-red pa4 br-pill mw5 center" ]
            [ text "Progress" ]
        , handleResetWorkout model
        ]


goToWorkout : Model -> Html msg
goToWorkout model =
    if model.workoutInProgress then
        continueWorkout

    else
        trackWorkout


continueWorkout : Html msg
continueWorkout =
    a [ class "white no-underline", Route.href Route.Workout ]
        [ p [ class "headline pointer mb4 bg-navy pa4 br-pill mw5 center" ]
            [ text "Continue Workout" ]
        ]


trackWorkout : Html msg
trackWorkout =
    a [ class "white no-underline", Route.href Route.ChooseWorkout ]
        [ p [ class "headline pointer mb4 bg-navy pa4 br-pill mw5 center" ]
            [ text "Track Workout" ]
        ]


handleResetWorkout : Model -> Html msg
handleResetWorkout model =
    if model.workoutInProgress then
        a
            [ Route.href Route.ChooseWorkout
            , class "no-underline navy mt5 f6 db"
            ]
            [ text "reset workout" ]

    else
        span [] []
