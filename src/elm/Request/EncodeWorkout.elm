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
                , ( "exercises", object <| encodeAllExercises workout )
                ]


encodeAllExercises : Workout -> List ( String, Value )
encodeAllExercises workout =
    workout.progress
        |> Dict.map encodeExercise
        |> Dict.values


encodeExercise : String -> ExerciseProgress -> ( String, Value )
encodeExercise exerciseId progress =
    ( exerciseId
    , object
        [ ( "complete", bool progress.complete )
        , ( "sets", list <| List.map (encodeRecordedSet) progress.sets )
        ]
    )


encodeRecordedSet : RecordedSet -> Value
encodeRecordedSet recordedSet =
    object
        [ ( "user", string <| toString recordedSet.user )
        , ( "weight", int recordedSet.weight )
        , ( "reps", int recordedSet.reps )
        ]
