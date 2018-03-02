module State exposing (..)

import Data.Workout exposing (currentExercises, defaultExercises)
import Dict
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
            { model
                | currentWorkout = updateCurrentSet string model.currentWorkout
            }
                ! []

        InputReps string ->
            model ! []


updateCurrentSet : String -> Maybe Workout -> Maybe Workout
updateCurrentSet string workoutMaybe =
    workoutMaybe
        |> Maybe.map (\workout -> { workout | exercises = Dict.empty })


updateWeight : String -> CurrentSet -> CurrentSet
updateWeight weightStr ( _, b ) =
    ( String.toInt weightStr, b )


updateReps : String -> CurrentSet -> CurrentSet
updateReps repStr ( a, _ ) =
    ( a, String.toInt repStr )


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
