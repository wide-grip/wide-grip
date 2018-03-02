module Data.Workout exposing (..)

import Types exposing (..)


workoutNameToString : WorkoutName -> String
workoutNameToString workoutName =
    case workoutName of
        UserDefined str ->
            str

        workoutName ->
            toString workoutName


defaultExercises : WorkoutName -> List Exercise
defaultExercises session =
    case session of
        Push ->
            [ Exercise 1 "Bench press" [] False emptySet
            , Exercise 2 "Incline bench press" [] False emptySet
            , Exercise 3 "Rope pull down" [] False emptySet
            ]

        Pull ->
            [ Exercise 4 "Pull ups" [] False emptySet
            , Exercise 5 "Seated rows" [] False emptySet
            , Exercise 6 "Bicep curls" [] False emptySet
            ]

        Legs ->
            [ Exercise 7 "Squats" [] False emptySet
            , Exercise 8 "Lunges" [] False emptySet
            , Exercise 9 "Calf raises" [] False emptySet
            ]

        UserDefined string ->
            []


emptySet : ( Result String Int, Result String Int )
emptySet =
    ( Err "", Err "" )


currentExercises : Maybe Workout -> List Exercise
currentExercises =
    Maybe.map .exercises >> Maybe.withDefault []


currentSessionType : Maybe Workout -> Maybe WorkoutName
currentSessionType =
    Maybe.map .workoutName
