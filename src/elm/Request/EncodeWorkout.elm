module Request.EncodeWorkout exposing (..)

import Date exposing (Date)
import Dict
import Json.Encode exposing (..)
import Types exposing (..)


encodeCurrentWorkout : Model -> Maybe Value
encodeCurrentWorkout model =
    model.currentWorkout |> Maybe.andThen (encodeWorkout model.today)


encodeWorkout : Date -> Workout -> Maybe Value
encodeWorkout today workout =
    if List.isEmpty <| encodeAllExercises workout then
        Nothing
    else
        Just <|
            object
                [ ( "date", float <| Date.toTime today )
                , ( "workoutName", string <| toString workout.workoutName )
                , ( "exercises", list <| encodeAllExercises workout )
                ]


encodeAllExercises : Workout -> List Value
encodeAllExercises workout =
    workout.progress
        |> Dict.filter (always nonEmptyExercise)
        |> Dict.map encodeExercise
        |> Dict.values
        |> List.concat


nonEmptyExercise : ExerciseProgress -> Bool
nonEmptyExercise progress =
    progress.sets
        |> List.isEmpty
        |> not


encodeExercise : String -> ExerciseProgress -> List Value
encodeExercise exerciseId progress =
    List.map (encodeRecordedSet exerciseId) progress.sets


encodeRecordedSet : String -> RecordedSet -> Value
encodeRecordedSet exerciseId recordedSet =
    object
        [ ( "user", string <| toString recordedSet.user )
        , ( "weight", int recordedSet.weight )
        , ( "reps", int recordedSet.reps )
        , ( "exerciseId", string exerciseId )
        ]
