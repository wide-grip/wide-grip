module Data.Workout exposing (..)

import Types exposing (..)


workoutNameToString : WorkoutName -> String
workoutNameToString workoutName =
    case workoutName of
        UserDefined str ->
            str

        workoutName ->
            toString workoutName


defaultExercises : WorkoutName -> List String
defaultExercises session =
    case session of
        Push ->
            [ "Bench press"
            , "Incline bench press"
            , "Rope pull down"
            ]

        Pull ->
            [ "Pull ups"
            , "Seated rows"
            , "Bicep curls"
            ]

        Legs ->
            [ "Squats"
            , "Lunges"
            , "Calf raises"
            ]

        UserDefined string ->
            []


currentExercises : Maybe Workout -> List String
currentExercises =
    Maybe.map .exercises >> Maybe.withDefault []


currentSessionType : Maybe Workout -> Maybe WorkoutName
currentSessionType =
    Maybe.map .workoutName
