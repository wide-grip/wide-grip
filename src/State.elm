module State exposing (..)

import Data.Workout exposing (defaultExercises)
import Types exposing (..)


-- INIT


init : ( Model, Cmd Msg )
init =
    initialModel ! []


initialModel : Model
initialModel =
    { view = Home
    , currentWorkout = Nothing
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetView view ->
            { model | view = view } ! []

        StartWorkout workoutName ->
            { model
                | currentWorkout = initWorkoutWithWorkoutName workoutName
                , view = SelectExercisesForWorkout
            }
                ! []

        ConfirmExercises ->
            { model | view = StartAnExercise } ! []


initWorkoutWithWorkoutName : WorkoutName -> Maybe Workout
initWorkoutWithWorkoutName workoutName =
    Just
        { workoutName = workoutName
        , exercises = defaultExercises workoutName
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
