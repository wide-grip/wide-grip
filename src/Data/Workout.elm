module Data.Workout exposing (..)

import Dict exposing (Dict)
import Types exposing (..)


workoutNameToString : WorkoutName -> String
workoutNameToString workoutName =
    case workoutName of
        UserDefined str ->
            str

        workoutName ->
            toString workoutName


defaultExercises : WorkoutName -> Dict Int Exercise
defaultExercises session =
    case session of
        Push ->
            Dict.fromList
                [ ( 1, Exercise "Bench press" [] False emptySet )
                , ( 2, Exercise "Incline bench press" [] False emptySet )
                , ( 3, Exercise "Rope pull down" [] False emptySet )
                ]

        Pull ->
            Dict.fromList
                [ ( 4, Exercise "Pull ups" [] False emptySet )
                , ( 5, Exercise "Seated rows" [] False emptySet )
                , ( 6, Exercise "Bicep curls" [] False emptySet )
                ]

        Legs ->
            Dict.fromList
                [ ( 7, Exercise "Squats" [] False emptySet )
                , ( 8, Exercise "Lunges" [] False emptySet )
                , ( 9, Exercise "Calf raises" [] False emptySet )
                ]

        UserDefined string ->
            Dict.empty


emptySet : ( Result String Int, Result String Int )
emptySet =
    ( Err "", Err "" )


currentExercises : Maybe Workout -> Dict Int Exercise
currentExercises =
    Maybe.map .exercises >> Maybe.withDefault Dict.empty


currentSessionType : Maybe Workout -> Maybe WorkoutName
currentSessionType =
    Maybe.map .workoutName
