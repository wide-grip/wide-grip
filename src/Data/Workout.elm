module Data.Workout exposing (..)

import Types exposing (..)


sessionTypeToString : Session -> String
sessionTypeToString session =
    case session of
        UserDefined str ->
            str

        sessionType ->
            toString sessionType


defaultExercises : Session -> List String
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


currentSessionType : Maybe Workout -> Maybe Session
currentSessionType =
    Maybe.map .session
