module Json.Firebase.Encode exposing
    ( encodeCurrentWorkout
    , encodeExercise
    , encodeRecordedSet
    , encodeWorkout
    , nonEmptyExercise
    )

import Data.Workout exposing (workoutNameToString)
import Dict exposing (Dict)
import Json.Encode exposing (..)
import Time
import Types exposing (..)


encodeCurrentWorkout : Model -> Maybe Value
encodeCurrentWorkout model =
    Maybe.andThen (encodeWorkout model.today) model.currentWorkout


encodeWorkout : Time.Posix -> Workout -> Maybe Value
encodeWorkout today workout =
    if List.isEmpty <| allExercises workout then
        Nothing

    else
        Just <|
            object
                [ ( "date", int <| Time.posixToMillis today )
                , ( "workoutName", string <| workoutNameToString workout.workoutName )
                , ( "exercises", list encodeExercise <| allExercises workout )
                ]


allExercises : Workout -> List ( String, ExerciseProgress )
allExercises =
    .progress >> Dict.filter (always nonEmptyExercise) >> Dict.toList


nonEmptyExercise : ExerciseProgress -> Bool
nonEmptyExercise =
    .sets >> List.isEmpty >> not


encodeExercise : ( String, ExerciseProgress ) -> Value
encodeExercise ( exerciseId, exerciseProgress ) =
    list (encodeRecordedSet exerciseId) exerciseProgress.sets


encodeRecordedSet : String -> RecordedSet -> Value
encodeRecordedSet exerciseId recordedSet =
    object
        [ ( "user", string recordedSet.user )
        , ( "weight", int recordedSet.weight )
        , ( "reps", int recordedSet.reps )
        , ( "exerciseId", string exerciseId )
        ]
