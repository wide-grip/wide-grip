module State exposing (..)

import Data.Workout exposing (currentExercises, defaultExercises)
import Dict
import Types exposing (..)
import Dict exposing (Dict)


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
            { model | currentWorkout = updateInputWeight string model.currentWorkout } ! []

        InputReps string ->
            { model | currentWorkout = updateInputReps string model.currentWorkout } ! []


updateInputReps : String -> Maybe Workout -> Maybe Workout
updateInputReps string workoutMaybe =
    workoutMaybe |> Maybe.map (\workout -> { workout | exercises = updateExercisesWith updateCurrentSetReps string workout.currentExercise workout.exercises })


updateInputWeight : String -> Maybe Workout -> Maybe Workout
updateInputWeight string workoutMaybe =
    workoutMaybe |> Maybe.map (\workout -> { workout | exercises = updateExercisesWith updateCurrentSetWeight string workout.currentExercise workout.exercises })


updateExercisesWith : (String -> Exercise -> Exercise) -> String -> Maybe Int -> Dict Int Exercise -> Dict Int Exercise
updateExercisesWith f weightStr exerciseId exercises =
    exerciseId
        |> Maybe.map (\id -> Dict.update id (Maybe.map (f weightStr)) exercises)
        |> Maybe.withDefault exercises


updateCurrentSetReps : String -> Exercise -> Exercise
updateCurrentSetReps weightStr exercise =
    { exercise | currentSet = updateReps weightStr exercise.currentSet }


updateCurrentSetWeight : String -> Exercise -> Exercise
updateCurrentSetWeight weightStr exercise =
    { exercise | currentSet = updateWeight weightStr exercise.currentSet }


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
