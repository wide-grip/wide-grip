module Data.Workout exposing
    ( Progress
    , Set
    , Workout
    , empty
    , progress
    , toList
    , workout
    )

import Dict exposing (Dict)


type alias Workout =
    Dict String Progress


type alias Progress =
    { exerciseId : String
    , complete : Bool
    , sets : List Set
    }


type alias Set =
    { user : String
    , weight : Float
    , reps : Int
    }



-- Construct


empty : Workout
empty =
    Dict.empty


toList : Workout -> List Progress
toList =
    Dict.values


progress : String -> Bool -> List Set -> Progress
progress =
    Progress


workout : List Progress -> Workout
workout =
    List.map (\p -> ( p.exerciseId, p )) >> Dict.fromList
