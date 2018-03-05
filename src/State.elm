module State exposing (..)

import Data.Ports exposing (receiveExercises)
import Data.Workout exposing (..)
import Date
import Request.Exercises exposing (decodeExercises)
import Types exposing (..)


-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    initialModel flags ! []


initialModel : Flags -> Model
initialModel flags =
    { view = Home
    , today = Date.fromTime flags.now
    , exercises = Err "no exercises yet"
    , currentWorkout = Nothing
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetView view ->
            setView view model ! []

        StartWorkout workoutName ->
            handleStartWorkout workoutName model ! []

        ConfirmExercises ->
            setView StartAnExercise model ! []

        StartExercise id ->
            (model
                |> updateCurrentWorkout (updateCurrentExercise id)
                |> setView RecordSet
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

        FinishCurrentExercise ->
            (model
                |> updateCurrentWorkout handleFinishSet
                |> setView StartAnExercise
            )
                ! []

        ReceiveExercises val ->
            { model | exercises = decodeExercises val } ! []


setView : View -> Model -> Model
setView view model =
    { model | view = view }


handleStartWorkout : WorkoutName -> Model -> Model
handleStartWorkout workoutName model =
    case model.exercises of
        Ok allExercises ->
            { model
                | currentWorkout = initWorkout workoutName [ Rob, Andrew ] allExercises
                , view = SelectExercisesForWorkout
            }

        Err _ ->
            model


initWorkout : WorkoutName -> List User -> AllExercises -> Maybe Workout
initWorkout workoutName users allExercises =
    Just
        { workoutName = workoutName
        , progress = defaultExercises workoutName users allExercises
        , currentExercise = Nothing
        , users = users
        }


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
    receiveExercises ReceiveExercises
