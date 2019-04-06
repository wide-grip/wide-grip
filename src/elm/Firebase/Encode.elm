module Firebase.Encode exposing (workout)

import Dict exposing (Dict)
import Json.Encode exposing (..)
import Time
import Workout exposing (..)


workout : Time.Posix -> Workout -> Maybe Value
workout today workout_ =
    if List.isEmpty <| allExercises workout_ then
        Nothing

    else
        Just <|
            object
                [ ( "date", int <| Time.posixToMillis today )
                , ( "workoutName", string <| workoutNameToString workout_.workoutName )
                , ( "exercises", list encodeExercise <| allExercises workout_ )
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
