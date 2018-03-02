module State exposing (..)

import Data.Workout exposing (currentExercises, defaultExercises)
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

        StartExercise id ->
            { model
                | view = RecordSet
                , currentWorkout = updateCurrentExercise id model.currentWorkout
            }
                ! []

        InputWeight string ->
            model ! []

        InputReps string ->
            model ! []


updateCurrentExercise : Int -> Maybe Workout -> Maybe Workout
updateCurrentExercise id =
    Maybe.map (\workout -> { workout | currentExercise = Just id })


initWorkoutWithWorkoutName : WorkoutName -> Maybe Workout
initWorkoutWithWorkoutName workoutName =
    Just
        { workoutName = workoutName
        , exercises = defaultExercises workoutName
        , currentExercise = Nothing
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
