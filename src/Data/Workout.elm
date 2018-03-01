module Data.Workout exposing (..)

import Types exposing (..)


sessionTypeToString : Session -> String
sessionTypeToString session =
    case session of
        UserDefined str ->
            str

        sessionType ->
            toString sessionType
