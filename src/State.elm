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
            setView view model ! []

        StartWorkout workoutName ->
            { model
                | currentWorkout = initWorkout [ Rob, Andrew ] workoutName
                , view = SelectExercisesForWorkout
            }
                ! []

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


setView : View -> Model -> Model
setView view model =
    { model | view = view }


initWorkout : List User -> WorkoutName -> Maybe Workout
initWorkout users name =
    Just
        { workoutName = name
        , exercises = defaultExercises users name
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
    Sub.none
