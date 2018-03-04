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
                | currentWorkout = Just <| initWorkout [ Rob, Andrew ] workoutName
                , view = SelectExercisesForWorkout
            }
                ! []

        ConfirmExercises ->
            { model | view = StartAnExercise } ! []

        StartExercise id ->
            (model
                |> updateCurrentWorkout (updateCurrentExercise id)
                |> updateView RecordSet
            )
                ! []

        InputWeight weightStr ->
            updateCurrentWorkout (updateInputWeight weightStr) model ! []

        InputReps repStr ->
            updateCurrentWorkout (updateInputReps repStr) model ! []

        SetCurrentUser user ->
            updateCurrentWorkout (updateCurrentUser user) model ! []

        SubmitSet ->
            updateCurrentWorkout handleSubmitSet model ! []


updateView : View -> Model -> Model
updateView view model =
    { model | view = view }


updateCurrentWorkout : (Workout -> Workout) -> Model -> Model
updateCurrentWorkout f model =
    { model | currentWorkout = Maybe.map f model.currentWorkout }


handleSubmitSet : Workout -> Workout
handleSubmitSet workout =
    if validSet workout then
        updateCurrentExerciseWith submitSet workout
    else
        workout



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
