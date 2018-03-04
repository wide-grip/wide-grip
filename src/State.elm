module State exposing (..)

import Data.Workout exposing (..)
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
                | currentWorkout = Just <| initWorkoutWithName workoutName
                , view = SelectExercisesForWorkout
            }
                ! []

        ConfirmExercises ->
            { model | view = StartAnExercise } ! []

        StartExercise id ->
            { model
                | view = RecordSet
                , currentWorkout = Maybe.map (updateCurrentExercise id) model.currentWorkout
            }
                ! []

        InputWeight weightStr ->
            { model | currentWorkout = Maybe.map (inputWeight weightStr) model.currentWorkout } ! []

        InputReps repStr ->
            { model | currentWorkout = Maybe.map (inputReps repStr) model.currentWorkout } ! []

        SubmitSet ->
            { model | currentWorkout = Maybe.map handleSubmitSet model.currentWorkout } ! []


handleSubmitSet : Workout -> Workout
handleSubmitSet workout =
    if validSet workout then
        { workout | exercises = updateExercisesWith submitSet workout.currentExercise workout.exercises }
    else
        workout



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
