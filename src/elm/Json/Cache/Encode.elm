module Json.Cache.Encode exposing
    ( encodeAllExercises
    , encodeCurrentExercise
    , encodeCurrentWorkout
    , encodeExercise
    , encodeExerciseProgress
    , encodeRecordedSet
    , encodeWorkout
    )

import Data.Workout exposing (workoutNameToString)
import Dict
import Json.Encode exposing (..)
import Time
import Types exposing (..)


encodeCurrentWorkout : Model -> Maybe Value
encodeCurrentWorkout model =
    model.currentWorkout |> Maybe.andThen (encodeWorkout model.today)


encodeWorkout : Time.Posix -> Workout -> Maybe Value
encodeWorkout today workout =
    if List.isEmpty <| encodeAllExercises workout then
        Nothing

    else
        Just <|
            object
                [ ( "date", int <| Time.posixToMillis today )
                , ( "workoutName", string <| workoutNameToString workout.workoutName )
                , ( "currentExercise", encodeCurrentExercise workout.currentExercise )
                , ( "users", list string workout.users )
                , ( "exercises", object <| encodeAllExercises workout )
                ]


encodeCurrentExercise : Maybe Exercise -> Value
encodeCurrentExercise currentExercise =
    currentExercise
        |> Maybe.map encodeExercise
        |> Maybe.withDefault null


encodeAllExercises : Workout -> List ( String, Value )
encodeAllExercises workout =
    workout.progress
        |> Dict.map encodeExerciseProgress
        |> Dict.values


encodeExerciseProgress : String -> ExerciseProgress -> ( String, Value )
encodeExerciseProgress exerciseId progress =
    ( exerciseId
    , object
        [ ( "complete", bool progress.complete )
        , ( "sets", list encodeRecordedSet progress.sets )
        , ( "exercise", encodeExercise progress.exercise )
        ]
    )


encodeExercise : Exercise -> Value
encodeExercise ex =
    object
        [ ( "id", string ex.id )
        , ( "name", string ex.name )
        , ( "workoutName", string <| workoutNameToString ex.workoutName )
        ]


encodeRecordedSet : RecordedSet -> Value
encodeRecordedSet recordedSet =
    object
        [ ( "user", string recordedSet.user )
        , ( "weight", int recordedSet.weight )
        , ( "reps", int recordedSet.reps )
        ]
