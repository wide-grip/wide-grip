module Page.Workout exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Context exposing (Context)
import Data.Exercise as Exercise
import Data.Workout as Workout
import Data.Workout.Cache as Cache
import Html exposing (..)
import Html.Attributes exposing (class)
import Json.Encode as Encode
import Ports
import Route
import Views.Icons as Icons



-- Model


type alias Model =
    { context : Context
    , workout : Workout.Workout
    }


type Msg
    = ReceiveWorkout Encode.Value



-- Init


init : Context -> ( Model, Cmd Msg )
init context =
    ( initialModel context
    , Ports.restoreWorkoutFromCache ()
    )


initialModel : Context -> Model
initialModel context =
    { context = context
    , workout = Workout.empty
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveWorkout workout ->
            ( handleReceiveWorkout model workout, Cmd.none )


handleReceiveWorkout : Model -> Encode.Value -> Model
handleReceiveWorkout model value =
    case Cache.decodeWorkout value of
        Ok workout ->
            { model | workout = workout }

        Err _ ->
            model



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.receiveWorkoutFromCache ReceiveWorkout



-- View


view : Model -> Html Msg
view model =
    div []
        [ div [ class "mt5 mw5 center" ] <| renderExercises model
        , div [ class "center tc" ] [ Icons.fistButton "finish workout" ]
        ]


renderExercises : Model -> List (Html Msg)
renderExercises model =
    model.workout
        |> Workout.toList
        |> List.map (startExercise model)


startExercise : Model -> Workout.Progress -> Html msg
startExercise model progress =
    a [ class "no-underline navy", Route.href <| Route.Exercise (Just progress.exerciseId) ]
        [ div
            [ class "flex pointer justify-between mb3 bg-animate hover-bg-navy hover-white items-center br-pill ba b--navy"
            ]
            [ p [ class "ttu ma3 tracked" ] [ text <| Maybe.withDefault "" <| exerciseName progress model.context.exercises ]
            , div [ class "ma3" ] [ renderIcon progress ]
            ]
        ]


exerciseName : Workout.Progress -> Exercise.Exercises -> Maybe String
exerciseName progress =
    Exercise.getById progress.exerciseId >> Maybe.map .name


renderIcon : Workout.Progress -> Html msg
renderIcon progress =
    if progress.complete then
        Icons.tick

    else
        Icons.fist
