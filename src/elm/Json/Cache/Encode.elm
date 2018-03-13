module Json.Cache.Encode exposing (..)

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
                , ( "currentExercise", encodeCurrentExercise workout.currentExercise )
                , ( "users", list <| List.map (toString >> string) workout.users )
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
        , ( "sets", list <| List.map (encodeRecordedSet) progress.sets )
        , ( "exercise", encodeExercise progress.exercise )
        ]
    )


encodeExercise : Exercise -> Value
encodeExercise ex =
    object
        [ ( "id", string ex.id )
        , ( "name", string ex.name )
        , ( "workoutName", string <| toString ex.workoutName )
        ]


encodeRecordedSet : RecordedSet -> Value
encodeRecordedSet recordedSet =
    object
        [ ( "user", string <| toString recordedSet.user )
        , ( "weight", int recordedSet.weight )
        , ( "reps", int recordedSet.reps )
        ]
